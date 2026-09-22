# PLUS_SESSION_PROMPT — PKG-0179: ZINTEGROWANY MEGA-PAKIET WDROŻENIA AUDYTU (360° QUALITY PASS)

> **DLA AGENTA / MODELU WYKONAWCZEGO**: Otrzymujesz rolę Głównego Architekta Silnika, Dyrektora Kreatywnego i Lead Programmera (D-025, D-085, ADR-004). Działasz w trybie **High-Throughput Mega-Package (2x–5x Batch Size, D-085)**.
> Twoim zadaniem jest wdrożenie w **jednym, nieprzerwanym przejściu (w jednym bundle'u)** wszystkich zaakceptowanych poprawek technicznych, polonistycznych, wizualnych oraz autorskich innowacji klimatu zdefiniowanych w `docs/rebuild/AUDIT_IMPLEMENTATION_PLAN.md`.
> Masz pełną autonomię decyzyjną — nie pytaj o pozwolenie ani nie czekaj na dodatkowy feedback. Wszystkie zmiany zapisuj od razu na dysk.

---

## 1. TWARDE REGUŁY I GRANICE PROJEKTU (NON-NEGOTIABLE)

Zanim dotkniesz kodu, musisz bezwzględnie przestrzegać konstytucji projektu (`AGENTS.md`):
1. **SCOPE BOUNDARY (D-098):** *Getting Strange* to wyłącznie gra na PC w silniku Godot 4.7 (GDScript). Żadnych technologii webowych, HTML/JS, Electrona ani portali.
2. **OBSTACLE RULE (D-099):** Narracyjny thriller relacyjny, zero platformówki arcade. Żadnych ruchomych platform, pływających klocków, kolców, patroli wrogów, pasków zdrowia czy zagadek na timing skoku. Każda przeszkoda ma wynikać ze świata i dać się opisać jednym zdaniem bez słowa „gracz”.
3. **NO GIT / LOKALNY STAN DYSKU (D-016):** Projekt nie używa Gita. Pliki na dysku są jedynym stanem. Zapisuj zmiany natychmiast na dysk.
4. **BLOKADA WYDANIA (D-168):** Żadnych nowych binariów `.exe` w drzewie projektu. Status `GATE-REL` pozostaje zablokowany do bezpośredniej dyspozycji właściciela.
5. **KANON SKALI ŚWIATA (`docs/WORLD_SCALE.md`):** 1 m = 54 px (±10%). Lena: 87 px na płótnie 64×104 px z pivotem `(32, 96)`. Otwory drzwiowe: 109×45 px, pojazdy: 105×58 px, włazy: 64×64 px.
6. **EPISTEMOLOGICZNA SEPARACJA DOWODU (D-012, ADR-003):** Testy automatyczne dowodzą technicznego spełnienia kontraktu silnika, a nie ludzkiego poczucia „frajdy” czy „emocji”.

---

## 2. BAZA REFERENCYJNA I KOLEJNOŚĆ CZYTANIA

Przed rozpoczęciem edycji przeczytaj:
1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. `docs/rebuild/AUDIT_IMPLEMENTATION_PLAN.md` (nadrzędna specyfikacja techniczna pakietu)
5. `docs/rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md`

Następnie uruchom baseline weryfikacji:
```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

---

## 3. ZAKRES PRAC DO WYKONANIA W JEDNYM BUNDLE'U (PKG-0179)

Wykonaj kolejno wszystkie 6 strumieni roboczych zdefiniowanych w `docs/rebuild/AUDIT_IMPLEMENTATION_PLAN.md`:

### STRUMIEŃ 1: HIGIENA PAMIĘCI I ELIMINACJA WYCIEKÓW OBJECTDB
1. **`scripts/environment/threshold_binder.gd`**:
   - Zastąp anonimowe lambdy `func(): _complete(station)` stałą metodą `_on_threshold_crossed(station: Node2D)`.
   - W `_rewire()` iteruj po połączeniach i odłączaj stare wywołania przed podpięciem `Callable(_on_threshold_crossed).bind(station)`.
   - Dodaj jawną metodę `_exit_tree()`.
2. **`scripts/visual/crisp_diegetic_text.gd`**:
   - Dodaj metodę `_exit_tree()`, która odłącza `_on_accessibility_changed` z `/root/GameStateManager` (jeśli manager istnieje i sygnał jest połączony).
3. **`scripts/ui/crt_dialogue_box.gd`**:
   - Dodaj metodę `_exit_tree()`, która bezpiecznie odłącza `settings_changed` oraz `accessibility_changed` z `/root/GameStateManager`.
4. **`scripts/levels/station_01.gd`**:
   - W procedurze odtwarzania `MartaMessageChime` obsłuż tryb headless (`DisplayServer.get_name() == "headless"`): uwalniaj węzeł audio jednorazowym sygnałem klatki `get_tree().process_frame.connect(voice.queue_free, CONNECT_ONE_SHOT)`, eliminując wiszące osierocone węzły bez drivera audio.

### STRUMIEŃ 2: KINEMATYKA I BEZPIECZEŃSTWO EKSPORTU
1. **`scripts/player/prototype_player.gd`**:
   - W procedurze schodzenia ze stopnia w linii 337 uniezależnij wektor przesunięcia od statycznego `signf(_facing)`. Wyliczaj kierunek w oparciu o wektor prędkości `velocity.x` lub wejście poziome gracza (`Input.get_axis`), eliminując gwałtowne szarpnięcie przy zatrzymywaniu się na krawędzi.
2. **`tests/pkg_0160_smoke_test.gd`**:
   - Zamień niebezpieczne dla archiwum `.pck` wywołanie `Image.load_from_file()` na standardowy loader zasobów silnika: `load("res://assets/characters/portraits/marta.png") as Texture2D`. Upewnij się, że nie rzuca ostrzeżeń podczas eksportu.

### STRUMIEŃ 3: SPÓJNOŚĆ WIZUALNA, PIPELINE PICSART GEN-AI I TEST M3
1. **Wygaszanie UI w kadrach testowych M3 (`tools/capture_pkg_0177.gd` / `tools/capture_preview.gd`)**:
   - Przed wykonaniem zrzutu kadrów M3 ukryj warstwy interfejsu (Layer 10, 16, 20), aby czarna belka `CRTDialogueBox` (102 px) nie zasłaniała 28.3% kadru ani postaci dr Wierzbickiej w Stacji 11.
   - Ponownie wygeneruj czyste kadry monochromatyczne w `reports/pkg_0177/mono/` (lub nowym katalogu `reports/pkg_0179/mono/`).
2. **Generacja i Spójnienie Grafiki przez Picsart CLI (`gen-ai` w terminalu)**:
   - **Narzędzie:** Używaj Picsart CLI (`gen-ai` w terminalu) — jest w pełni uwierzytelnione i gotowe do pracy.
   - **Dobór modeli:**
     * Do generowania wysokiej jakości nowych grafik bazowych i obiektów: modele **`flux`** lub **`gpt`** (np. `flux-pro`, `gpt-image`).
     * Do generowania grafik „podobnych stylem”, ale przedstawiających inną postać lub zachowujących ciągłość tożsamości: modele zawierające kontekst, w szczególności **`flux kontext`** (`flux-kontext-pro`, `gen-ai character`).
   - **Budżet kredytów:** **Nie musisz oszczędzać kredytów Picsart!** Masz pełną zgodę na eksperymentowanie i generowanie ulepszonych grafik do wszystkich słabszych wizualnie miejsc w grze (np. tramwaj w zimnym otwarciu i Stacji 03/04, drzwi, szafy techniczne, konsole, rekwizyty).
   - **Twardy kanon stylu:** **Styl grafiki ma się nie zmieniać.** To, jak wygląda Lena (`LenaVisualRig` / `lena.png`), jest wzorcem dla całego projektu. Wszystko (postacie, portrety, NPC, obiekty świata) musi być bezwzględnie spójne ze stylem Leny (retro pixel art / Rowien Vector-Stage, wycięte tło przez `gen-ai remove-bg`, stała skala 1 m = 54 px).
3. **Unifikacja portretu Marty (`assets/characters/portraits/marta.png`) i postaci pobocznych**:
   - Przeprocesuj portret Marty przy użyciu `flux kontext` z referencją stylu Leny lub skryptu normalizującego (`tools/unify_portrait_style.py`): przeskaluj do natywnej siatki retro, oczyść przezroczystość z białych artefaktów i zindeksuj kolory do 16-barwnej technokratycznej palety z subtelnym ditheringiem Bayera, likwidując jaskraworóżowy szum anime AI.

### STRUMIEŃ 4: WARSZTAT POLONISTYCZNY I SZLIF DIALOGÓW
1. **Stacja 01 (`scripts/levels/station_01.gd`)**:
   - Zastąp sztuczne `Śluza czeka na zapis. Najpierw drugi odczyt i torba.` naturalną kwestią zmęczonego technika:  
     `Zostawię surowy odczyt, jutro będę tu wracać z raportem. Zbieram torbę.`
2. **Stacja 06 (`scripts/levels/station_06.gd`)**:
   - Zastąp anachroniczne `Cache w telefonie. Najprostsze.` ugruntowanym sceptycyzmem analogowym:  
     `Błąd w druku albo stara tabliczka. Zawsze najpierw szuka się bałaganu w papierach.`
3. **Stacja 14 (`scripts/levels/station_14.gd`)**:
   - Zastąp sztuczną wskazówkę L4 terminologią fizyczną aparatury:  
     `POMOC: Chwyć obejmę przed impulsem rozdzielnicy. Jeśli puścisz, most przejdzie na rezerwę i odetnie zasilanie.`
4. **Stacja 17 (`scripts/levels/station_17.gd` / `docs/narrative/DIALOGUE_SCRIPT.md`)**:
   - Zastąp aforystyczne zdanie Jakuba autentycznym językiem rzemieślnika kolejowego:  
     `JAKUB: Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena.`
5. Zaktualizuj pliki źródłowe, katalog faktów `scripts/campaign/cold_open_facts.gd` oraz zsynchronizuj `reports/all_player_texts_full.json`.

### STRUMIEŃ 5: AUTORSKIE INNOWACJE KLIMATU I REŻYSERII PRZESTRZENI
1. **„Cienie Przebiegu” w `scripts/visual/vibration_trace_display.gd`**:
   - Wprowadź zmienną `interference_factor: float` sterowaną odległością Leny od aparatury w Stacjach 01, 14, 15.
   - W `_draw()` rozszczep promień kineskopu na dwie fazy z mikro-drżeniem (przesunięcie 1.5–3.0 px) jako sensoryczny dowód, że ciało Leny zakłóca odczyt.
2. **Proceduralne podwójne echo kroków („Echo Ciała”)**:
   - W `scripts/audio/procedural_audio.gd` i `scripts/player/prototype_player.gd`: od Stacji 08 do 18 wprowadź drugie, stłumione stąpnięcie (opóźnienie 35–45 ms, -18 dB) symbolizujące obecność miejscowej Leny (z poszanowaniem trybu ograniczonego ruchu).
3. **Przewężenia architektoniczne (Stacje 02 i 15)**:
   - W Stacji 02 wprowadź przewężenie serwisowe (szerokość 48 px, wysokość 105 px) zmuszające do zwolnienia tempa bez skoków.
   - W Stacji 15 wprowadź uskok podłogi 14 px pokonywany automatycznym `_advance_curb_step()`.

### STRUMIEŃ 6: NOWA BRAMKA WERYFIKACYJNA I CERTYFIKACJA
1. **Utwórz `tests/pkg_0179_smoke_test.gd`**:
   - Sprawdź zerową liczbę wycieków `ObjectDB` po przeładowaniach scen.
   - Sprawdź poprawne odpinanie sygnałów w węzłach.
   - Sprawdź obecność nowych kwestii dialogowych i działanie interferencji oscyloskopu.
   - Zweryfikuj twardą regułę D-168 (brak plików `.exe`).
2. **Wepnij test do `tools/verify.ps1`** jako ostatnią bramkę:
   ```powershell
   Invoke-GodotGate `
       -Name 'PKG-0179 360 quality and audit remediation gate' `
       -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0179_smoke_test.gd')
   ```
3. **Uruchom pełną weryfikację**:
   ```powershell
   pwsh -NoProfile -File .\tools\verify.ps1
   ```
   *Wymagany wynik: exit code 0, brak błędów skryptów, brak regresji w 14 bramkach produktu.*

---

## 4. PROTOKÓŁ ZAMKNIĘCIA SESJI (OBOWIĄZKOWY)

Po pomyślnym zakończeniu wszystkich kroków i zielonym wyniku `verify.ps1`:
1. Zaktualizuj `docs/CURRENT_STATE.md` (status PKG-0179: ZAMKNIĘTY).
2. Dodaj kompletny, samowystarczalny wpis do `docs/SESSION_LOG.md` (sekcja `## PKG-0179`).
3. Zaktualizuj `docs/INDEX.md` oraz `docs/ROADMAP.md`.
4. Wygeneruj nowy prompt handoffowy w `docs/NEXT_SESSION_PROMPT.md` (oczekiwanie na dyspozycję wydania `.exe` przez właściciela per D-168).
5. Zamroź stan snapshotem:
   ```powershell
   pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0179
   ```
6. Zgłoś raport końcowy z wymienionymi testami, metrykami wycieków i statusem bramek.
