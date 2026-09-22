# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0025: P3 Vertical Slice — „Wróciłaś” i spotkanie z Martą Kurek (Przestrzeń 07)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 07 z FULL_STORY.md („Wróciłaś” / Klatka schodowa na Osiedlu Tarasowym):
   - Klatka schodowa modernistycznego bloku mieszkalnego na Osiedlu Tarasowym (lastryko, stalowe balustrady, geometryczne spoczniki schodowe, przeszklona ściana z widokiem na deszczowe miasto i odcięte piętro).
   - Marta Kurek czekająca w progu otwartych drzwi mieszkania, ubrana do wyjścia w roboczej kurtce z torbą narzędziową na ramieniu (zamiast kwiatów).
   - Wdrożenie kluczowej sceny dialogowej D-02 z DIALOGUE_SCRIPT.md:
     - Marta: „Wróciłaś.”
     - Lena: „Pomyliła mnie pani z kimś.”
     - Marta: „Lena Wolska... Mieszkała tu. Siedemnaście dni temu wyszła. Nie wzięła butów na deszcz.”
     - Lena dociska paznokieć do szwu palca (gest obcy lokalnej Lenie); Marta patrzy na dłoń: „Nie... Twarz się zgadza. Reszta dopiero weszła po schodach.”
     - Anomalia klatki: „Możesz zostać na klatce. Tylko klatka dziś kończy się na trzecim piętrze, a jesteśmy na piątym.”
   - Interaktywne badanie klatki schodowej (tablica lokatorów z nazwiskiem Wolska/Kurek, geometryczny ślepy zaułek schodów kończących się w ścianie, skrzynki na listy, oświetlenie z czujnikiem ruchu).
   - Otwarcie drzwi do mieszkania (AirlockZone) prowadzące do Przestrzeni 08 (Mieszkanie po kimś).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio (kroki na klatce lastryko, echo spocznika, otwieranie skrzypiących drzwi mieszkania, blip dialogowy Marty Kurek o charakterystyce głosu 440 Hz / ciepły mat).
3. Podpięcie przejścia ze sceny Station 06 do Station 07 oraz weryfikacja automatyczna i wizualna.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 07)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-02)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
9. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0024 (Station 06 Autobus Linii 4: wnętrze, komunikat UCP, starszy pasażer, złota obrączka, badanie szwu palca, dojazd do Osiedla Tarasowego).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0024):
- Faza P3 w toku: Przestrzenie 01, 02, 03, 04, 05 oraz 06 (`station_01.tscn` .. `station_06.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi D-01, mechanika kołowrotu, nocna ulica Równi, autobus linii zastępczej i złota obrączka.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_07.tscn` i kontroler `scripts/levels/station_07.gd` dla Przestrzeni 07 („Wróciłaś” / Klatka schodowa na Osiedlu Tarasowym).
2. Zaimplementuj postać Marty Kurek w progu mieszkania, sekwencję dialogową D-02, badanie skrzynek/tablicy/ślepego biegu schodów i wejście do mieszkania.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 07.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_07.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0025`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0026.

KRYTERIA AKCEPTACJI
- Przestrzeń 07 (Station 07: „Wróciłaś”) poprawnie realizuje scenariusz Przestrzeni 07 z FULL_STORY.md i scenę dialogową D-02 z DIALOGUE_SCRIPT.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0025` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
