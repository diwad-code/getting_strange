# PKG-0118 — Foundation Slice 01–07 według kanonu 0.3

Rola: autonomiczny Lead Programmer, Narrative Designer i Art Director gry
`Getting Strange`. Pracuj krok po kroku bez proszenia o rutynowe decyzje.
Zatrzymaj się tylko przy prawdziwym blockerze spoza projektu.

## CEL SESJI

Zastąpić niespójny, częściowy runtime Station 01–07 pierwszym prawdziwym
pionowym wycinkiem kanonu 0.3. Pakiet ma jednocześnie dostarczyć:

1. siedem scen od pełnej normalności do pierwszej racjonalizowalnej rysy;
2. wyraźniejszą, cięższą i bardziej ludzką Lenę w ruchu i reakcji;
3. działający Pixel-Stage świata z ostrymi tekstami ponad nim;
4. guidance pokazujące zdarzenie przed myślą i pozwalające Lenie się mylić;
5. zapis/restart/trasy, testy treści i świeżą macierz capture.

Nie rozpoczynaj pustego projektu. Zachowaj techniczny szkielet Godot i usuń lub
adaptuj wyłącznie to, co przeczy nowemu wycinkowi.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`.
- Silnik: Godot `4.7.x`.
- Platformy docelowe: Windows i Linux.
- Viewport: `640x360`, fizyka `60 Hz`.
- Projekt jest wyłącznie grą Godot. Brak webu.
- Projekt nie ma Git. Nie uruchamiaj żadnych poleceń Git i nie inicjalizuj
  repozytorium.
- Ostatni zamknięty pakiet: `PKG-0117`, snapshot
  `snapshots/PKG-0117-2026-08-25/`.
- Oczekiwany baseline:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Oczekiwany wynik: `Verification passed.`, kod `0`. Ostrzeżenia historycznych
fixture'ów i `ObjectDB instances were leaked at exit` są znane, ale każdy
`SCRIPT ERROR`, parser error lub niezerowy kod jest blockerem technicznym do
naprawy.

### Obowiazkowa kolejnosc czytania

1. `AGENTS.md`.
2. `docs/INDEX.md`.
3. `docs/CURRENT_STATE.md`.
4. ten plik.
5. `docs/CREATIVE_REBUILD_PLAN.md`.
6. `docs/narrative/NARRATIVE_BIBLE.md`.
7. `docs/narrative/FULL_STORY.md`, wyłącznie 01–07 i reguły całego przebiegu.
8. `docs/narrative/CONTINUITY_TRACKER.md`, wiedza przed Station 08.
9. `docs/narrative/DIALOGUE_SCRIPT.md`, beaty 01–07 i voice sheet Leny/Marty.
10. `docs/LENA_CHARACTER_AND_ANIMATION.md`.
11. `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`.
12. `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`.
13. `VISUAL_DESIGN.md`.
14. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` przed zmianą colliders.
15. źródła i testy wymienione poniżej.

Użyj właściwych dodanych skilli zamiast ogólnych nawyków: Godot 2D animation
dla riga, story consistency dla wiedzy 01–07 oraz experience design dla pętli
obserwacja → hipoteza → czynność → zmiana. Przeczytaj pełne `SKILL.md` przed
działaniem i odrzuć regułę skilla, jeśli przeczy kanonowi projektu.

### Hierarchia prawdy

Aktualny runtime i test > pliki na dysku > `CURRENT_STATE` i ten prompt >
`ADR-007`/`D-114` > bible 0.3 > dokumenty historyczne i snapshoty.

Snapshot służy wyłącznie jako zamrożenie porównawcze. Nie kopiuj z niego
hurtowo i nie edytuj go.

## STAN ZASTANY DO REKONCYLIACJI

Na dysku istnieją częściowe komponenty rozpoczęte przed PKG-0117:

- `scripts/player/lena_visual_rig.gd`;
- `scripts/player/lena_animation_state.gd`;
- integracja w `prototype_player.gd` i `prototype_player.tscn`;
- `scripts/visual/world_pixel_compositor.gd`;
- `scripts/visual/crisp_diegetic_text.gd`;
- `scripts/core/guidance_beat.gd`;
- `scripts/core/narrative_guidance_service.gd`;
- `scripts/ui/inner_thought_surface.gd`;
- sceny i skrypty `station_01..07`;
- `tests/pkg_0117_smoke_test.gd`.

Ich API przechodzi test techniczny, ale nie jest równoznaczne z akceptacją
treści lub obrazu.

### KEEP

- separacja riga od fizyki;
- architektura warstw świata/ostrego tekstu/UI;
- serwis guidance i powierzchnia myśli;
- pokrycie techniczne oraz węzły integracji.

### ADAPT

- anatomia, skala, pozy, timing i aktorstwo Leny;
- shader/kompozycja i dowód faktycznej nearest-neighbor pixelizacji;
- GuidanceBeat do modelu `hypothesis_id` + `predicted_check`;
- wszystkie cele, teksty, rekwizyty i inscenizacja 01–07.

### RETIRE

- 02: korelacyjna anomalia, przekroczenie 1.42 i nieciągły cień;
- 03: alternatywna fotografia, podwójne kubki i „URLOP PRZERWANY”;
- 04: strażnik, żywy Jakub i jawny nadzór UCP;
- 05: brakujące piętro, ruchoma geometria i szept imienia;
- 06: pierścień, obca biografia i dialog o jej wcześniejszym życiu;
- 07: Marta w mieszkaniu, ślepe schody i brakujące piętro.

Nie zachowuj elementu `RETIRE` tylko dlatego, że stary smoke go oczekuje.
Zastąp jego pokrycie testem nowego kontraktu bez usuwania porównywalnej
głębokości sprawdzeń.

## KANON STATION 01–07

### 01 — Ostatni odczyt

- Cel: zamknąć pomiar przy Linii 4 i zdążyć do Marty.
- Rejestrator zgubił trzy sekundy; dyspozytor chce oznaczyć błąd czujnika.
- Gracz sprawdza mocowanie, kalibruje czujnik, robi czysty odczyt i zachowuje
  surową próbkę.
- Karta `LINIA 4 / LUKA 00:00:03` jest widoczna, lecz nieobjaśniana.
- O 20:40 kontakt dwóch Len zachodzi bez widocznej anomalii.

### 02 — Obejście serwisowe

- Znany skrót jest fizycznie zamknięty przez prawdziwe prace.
- Gracz czyta oznaczenia, sprawdza wygaszony obwód i wybiera bezpieczne obejście.
- Taśmy, ślady kół, wentylacja i światła dają kompletną przyczynę świata.
- Żadnego drugiego światła, podwójnego cienia, korelacji ani „zgodnego” wyniku.

### 03 — Wiadomość Marty

- Przystanek ma zwykłe opóźnienie i słaby zasięg.
- Marta: `Miałaś wrócić. Napisz tylko, czy jedziesz.`
- Lena kasuje dłuższą odpowiedź i wysyła `Tak`.
- Scena pokazuje bliskość oraz zmęczenie Marty bez ujawniania romantycznej
  relacji miejscowej Leny.

### 04 — Przejazd

- Czytnik ponownie pokazuje trzysekundową lukę z bufora.
- Lena restartuje urządzenie, zabezpiecza kartę i odkłada pracę.
- Pomnik Linii 4 mija szybę; Lena odwraca ekran w dół.
- Nie pojawia się żywy Jakub, UCP, nadzór ani diagnoza świata.

### 05 — Znana ulica

- Pełny oddech i punkt odniesienia; układ, deszcz i światła są znajome.
- Neutralny szyld `UCP / PRACE NOCNE` wygląda jak logo wykonawcy.
- Brak ruchomej architektury, szeptu imienia i brakującego piętra.
- Flaga `ordinary_return_complete` może zostać zachowana.

### 06 — Dwa rozkłady

- Papier i offline cache mają tę samą bieżącą datę, ale różne numery linii.
- Gracz porównuje datę, identyfikator wersji i nadjeżdżający pojazd.
- Pojazd potwierdza papier; Lena rozsądnie obwinia cache.
- Myśl podaje hipotezę i prawdziwe sprawdzenie, nie prawdę o świecie.

### 07 — Herbata dla Marty

- Scena jest rzeczywiście kioskiem/sklepem, nie klatką schodową pod nowym
  szyldem.
- Sprzedawca zna imię Leny i pyta o tę samą herbatę dla Marty.
- Lena pyta o ostatnią wizytę; sprzedawca wskazuje zwykły wpis sprzedaży i chce
  zamknąć sklep.
- Lena racjonalizuje płatnością albo podobną klientką; ciało zatrzymuje się przed
  wypowiedzią.
- Koniec sceny kieruje do sprawdzenia adresu w Station 08.

## ZAKRES MEGA-PAKIETU

### A. Treść i pętle

Każda stacja ma zapisane oraz wdrożone: cel, przeszkodę, obserwowalny stan,
czynność, zmianę świata i nowe oczekiwanie. Station 05 może być oddechem, ale
nadal wymaga świadomego przejścia i czytelnego celu.

### B. Lena

- Zachowaj własny projekt postaci; nie kopiuj sprite'ów, klatek, sylwetki,
  kostiumu ani kadrów z `Another World`.
- Zastosuj ogólne zasady: zamiar przed przesunięciem, ciężar bioder, kontakt
  stopy, hamowanie, czytelny zwrot i ekonomia pozy.
- Minimum wycinka: idle, start, walk, run, stop, turn, jump rise/fall, land,
  interact, examine i pierwsza unease reaction.
- Proceduralna zmiana kąta nie wystarcza jako dowód produkcyjnej animacji.
  Dodaj czytelne key poses/timing i pokaż je w capture.
- Nie nazywaj jakości zaakceptowaną bez inspekcji świeżych klatek.

### C. Pixel-Stage i tekst

- Świat, Lena, NPC i VFX przechodzą przez nearest-neighbor siatkę.
- Dialog, myśli, UI, rozkłady, terminale i każdy czytelny napis są
  kompozytowane później i ostro.
- Udowodnij technicznie warstwę oraz efektywny raster; nie polegaj wyłącznie na
  obecności klasy/shadera.
- Usuń lub przenieś player-facing `draw_string()` spod kompozytora w 01–07.

### D. Guidance i myśli

- Kolejność: pokaż → naprowadź → pomyśl → sprawdź.
- Obserwacja jest prawdziwa; interpretacja może się mylić; cel mechaniczny jest
  zawsze prawdziwy.
- Myśl automatyczna nie pojawia się przed stanem świata.
- L2/L3 działają po zastoju, z cooldownem co najmniej 8 s, bez spamowania i po
  postępie znikają.
- Marta i sprzedawca nie są automatami podającymi rozwiązanie.

### E. Stan, testy i capture

- Zachowaj trasę, restart, checkpoint i zapis.
- Dodaj lint player-facing treści 01–07 przeciw przedwczesnym diagnozom,
  lokalnej Lenie, Podstrukturze, świadomemu Anchor/Yield i żywemu Jakubowi.
- Testuj faktyczne cele oraz flagi nowych scen, nie tylko obecność węzłów.
- Zaktualizuj historyczne testy do nowej prawdy bez osłabiania pokrycia.
- Wykonaj normal-driver capture co najmniej: Lena idle/walk/stop/interact,
  Station 01 normalność, 03 wiadomość, 05 znana ulica, 06 oba rozkłady, 07 kiosk,
  dialog/myśl oraz ostry tekst nad pikselizowanym światem.

## POZA ZAKRESEM

- Station 08–43 poza konieczną zgodnością API trasy.
- Świadomy Anchor/Yield w kampanii.
- Nowe finały runtime.
- Migracja save schema dla drugiej połowy.
- Buildy, eksporty, itch, Steam, web, Android i marketing.
- Pełna lokalizacja narracji poza tekstem dotkniętym w 01–07.
- Deklaracje o strachu, zabawie, zrozumieniu lub jakości odbiorczej.

## KRYTERIA AKCEPTACJI

1. Station 01–05 nie mają jawnej anomalii ani informacji o innym świecie.
2. Station 06–07 zawierają dokładnie pierwsze, racjonalizowalne rysy z kanonu.
3. Aktywna treść 01–07 nie ujawnia miejscowej Leny, żywego Jakuba,
   Podstruktury ani metod Anchor/Yield.
4. Każda stacja ma wdrożoną pętlę cel → przeszkoda → czynność → zmiana.
5. Station 07 wygląda i działa jak kiosk, nie klatka schodowa z podmienionym
   szyldem.
6. Lena ma czytelne key poses i timing wszystkich wymaganych stanów; collider i
   fizyka pozostają stabilne.
7. Świat jest technicznie próbkowany nearest-neighbor, a wszystkie czytelne
   teksty 01–07 pozostają ostre przy skalach 1x–4x i text scale 85–115%.
8. Guidance pokazuje obserwację przed myślą, przechowuje hipotezę/sprawdzenie,
   respektuje cooldown i reset po postępie.
9. Trasa 01→07, restart, checkpoint i zapis przechodzą testy.
10. Lint wiedzy i pakietowy smoke przechodzą; nie ma parser/runtime errors.
11. Normal-driver captures zostały świeżo wykonane i obejrzane.
12. `pwsh -NoProfile -File .\tools\verify.ps1` kończy się kodem `0`.
13. Ograniczenia artystyczne i odbiorcze pozostają jawne.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po implementacji:

1. uruchom pakietowe testy oraz pełne `tools/verify.ps1`;
2. obejrzyj świeżą macierz capture normalnym sterownikiem;
3. zaktualizuj `CURRENT_STATE.md`, `ROADMAP.md`,
   `RISKS_AND_HYPOTHESES.md` i właściwe dokumenty narracyjne, jeśli runtime
   wymusił zmianę;
4. dopisz dokładnie jeden wpis `## PKG-0118:` do `SESSION_LOG.md`;
5. zastąp ten plik samowystarczalnym promptem kolejnego pakietu;
6. uruchom ponownie pełne verify po ostatniej edycji dokumentów;
7. wykonaj:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0118
```

Raport końcowy musi podać testy, ograniczenia, `PKG-0118`, ścieżkę handoffu i
snapshotu. Automaty potwierdzają kontrakty techniczne, nie emocje ani
zrozumienie przez gracza.
