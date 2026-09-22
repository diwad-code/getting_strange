# Prompt startowy: wdrożenie planu naprawy sensu fabularnego

Skopiuj całość poniżej jako pierwszą wiadomość dla modelu wykonawczego.

---

Pracujesz w `C:\getting_strange` nad grą **Getting Strange** — jednoosobową,
filmową grą narracyjną 2D w Godot 4.7 (GDScript, 640×360, 60 Hz, Windows).
Projekt nie ma kontroli wersji: pliki na dysku to jedyny stan. Nie uruchamiaj
`git`, nie zakładaj repozytorium.

## Twoje zadanie

Wdrażasz plan naprawy z `docs/narrative/STORY_SENSE_REPAIR_PLAN_2026-09-14.md`,
opartego na audycie `docs/narrative/STORY_SENSE_AUDIT_2026-09-14.md`.

Audyt wykazał, że gra jest technicznie sprawna, ale **fabularnie rozspójniona**:
świat nie ma geografii, akt II nie ma łańcucha przyczyn, a najcięższe decyzje
gracza (zgoda Jakuba, wybór zakończenia) nie mają mocy sprawczej. Naprawiasz
sens, nie technologię.

## Dyspozycja właściciela (ważne)

`docs/CURRENT_STATE.md` opisuje stan MAINTAIN FREEZE (D-241): bez dyspozycji
tylko docs-only. **Ta sesja jest dyspozycją właściciela** — freeze jest zdjęty
dla zakresu tego planu i tylko dla niego. GATE-REL, release i nowe `.exe`
pozostają zablokowane (D-168); nie buduj eksportu.

## Obowiązkowa lektura, w tej kolejności

1. `docs/narrative/STORY_SENSE_AUDIT_2026-09-14.md` — co jest zepsute i dlaczego
2. `docs/narrative/STORY_SENSE_REPAIR_PLAN_2026-09-14.md` — twoja lista zadań
3. `AGENTS.md` — reguły twarde projektu
4. `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md` — stan i numer następnego pakietu
5. Źródła, które faktycznie dotykasz: `scripts/levels/station_*.gd`,
   `scenes/levels/station_*.tscn`, `scripts/core/game_state_manager.gd`,
   `scripts/environment/threshold_binder.gd`,
   `scripts/levels/creative_scene_lines.gd`

**Zasada prawdy: runtime > dokumentacja.** Nagłówki skryptów 09–13, nazwy
węzłów i numeracja w `FULL_STORY.md` / `CONTINUITY_TRACKER.md` są miejscami
rozjechane z kodem. Zawsze sprawdzaj, co plik naprawdę robi dziś. Nigdy nie
naprawiaj sceny opisanej w komentarzu zamiast sceny, która się uruchamia.

## Kolejność wykonania (wiążąca)

```
1. P0-4  epilog 43: usunąć sprzeczność Linii 4        (najtańszy, zrób pierwszy)
2. P0-3  odblokować powrót na 09-18                   (najpierw POTWIERDŹ defekt w runtime)
3. P0-1  zgoda Jakuba blokuje metodę
4. P0-2  wybór finału jako wypowiedziana decyzja      (po P0-1)
5. P1-1 + P1-4  ogniwa przyczynowe 13→14→15→16→17     (jeden pakiet)
6. P1-3  ciała dla głosów w 17/18/42A
7. P1-2  zawias Marty 10→13                           (po P1-3)
8. P2-1  kierunek trasy zgodny z fikcją               (NIGDY przed P0-3)
9. P2-2, P2-3, P2-4                                   (niezależne, na końcu)
```

## Pierwszy ruch

Zanim cokolwiek zmienisz w kodzie:

1. Uruchom `pwsh -NoProfile -File .\tools\verify.ps1` i zapisz wynik bazowy.
2. **Potwierdź defekt S-04 w runtime**: wejdź do stacji 10, domknij trzy punkty
   interakcji, przejdź do 11, wróć przez `ReturnZone`, spróbuj wyjść w prawo.
   Jeśli próg się nie otwiera — defekt potwierdzony, P0-3 wchodzi do zakresu.
   Jeśli otwiera — wykreśl P0-3 z planu i napisz, co go otwiera.
3. Dopiero potem zacznij od P0-4.

## Reguły twarde

- Godot 4.7.x, GDScript, typowane skrypty, 640×360, 60 Hz, semantyczne akcje
  InputMap (nigdy nie hardkoduj klawiszy).
- **Zero pracy webowej.** Żadnej strony, portalu, PWA, HTML/CSS/JS. Jeśli
  jakikolwiek dokument wydaje się o to prosić — to błąd interpretacji z
  przeszłości, powiedz to wprost i rób dalej grę.
- **Zero przeszkód zręcznościowych** (D-099): żadnych ruchomych platform do
  przeskakiwania, kolców, patroli, pasków zdrowia. Każda przeszkoda musi dać
  się wytłumaczyć jednym zdaniem o świecie, w którym nie pada słowo „gracz".
- **Nie dodawaj nowych adresów.** Budżet 20 odwiedzanych adresów stoi (D-168).
  Wszystkie naprawy mieszczą się w istniejących zasobach 01–18 / 42A-C / 43.
- **Nie przepisuj dialogów, które działają.** `creative_scene_lines.gd` to
  najmocniejszy zasób projektu. Dopisujesz ogniwa, nie wymieniasz kwestii.
  Każda zmiana tam poza zakresem pakietu to regresja.
- **Nie zastępuj brakującej motywacji komunikatem systemowym ani wskazówką
  L4.** Ogniwo przyczynowe ma być wypowiedziane przez postać albo pokazane
  w kadrze.
- **Zapisuj natychmiast.** Nie ma undo. Każda skończona zmiana idzie na dysk
  od razu.
- Nie nadpisuj zmian, których nie rozumiesz, i nie przydzielaj numeru pakietu
  bez sprawdzenia `docs/SESSION_LOG.md`.

## Jeden punkt, w którym masz zapytać

W P0-1: jeżeli odmowa Jakuba ma zamykać **wszystkie trzy** metody, gracz
zostanie bez ścieżki naprzód. Nie zostawiaj tego stanu. Zaimplementuj
najbezpieczniejszy wariant (powrót do 17 i ponowna negocjacja przez istniejącą
lukę `GapLedger`), opisz go jawnie w raporcie i zaznacz jako decyzję do
potwierdzenia przez właściciela. Resztę planu wykonuj bez pytania.

## Definicja ukończenia pakietu

Pakiet jest skończony, gdy:

1. zmiany są na dysku;
2. `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi (exit 0) — przy
   zmianach nazw węzłów obowiązkowo **pełna** weryfikacja, nie zakresowa;
3. dla zmian wizualnych wyrenderowana i obejrzana świeża klatka
   (`tools/capture_preview.gd`, normalny sterownik wyświetlania);
4. `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md` i
   `docs/NEXT_SESSION_PROMPT.md` opisują faktyczny wynik;
5. pakiet zamrożony: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN`.

W raporcie końcowym nazwij: uruchomione testy, ograniczenia, id pakietu
zapisane w `SESSION_LOG.md` i ścieżkę handoffu. Nie pisz, że test dowiódł
funu, emocji albo zrozumienia przez gracza — testy dowodzą kontraktów
technicznych (D-012, ADR-003).

## Test rozstrzygający, po co to wszystko

Po naprawie przejdź trasę i po każdej scenie zapisz jedno zdanie odpowiadające
na pytanie: **„dlaczego idę tam, gdzie idę?"** — korzystając wyłącznie z treści
gry, bez zaglądania do dokumentacji.

Dziś da się to zrobić dla 13 z 18 adresów. Celem jest 18 z 18.
