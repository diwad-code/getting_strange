# NEXT_SESSION_PROMPT — PKG-0108

## CEL SESJI

Wykonać techniczny audyt hipotezy H-012: czy materialna, nieglitchowa
korekta i podstawowe akcenty Vector-Stage pozostają czytelne w logicznej
przestrzeni 640x360 oraz przy całkowitym skalowaniu 1x–4x. Audyt ma dostarczyć
mierzalnego materiału i jasno oddzielić dowód techniczny od hipotezy odbiorczej;
nie jest playtestem i nie może udawać opinii nowej osoby.

## SRODOWISKO I BASELINE

Godot 4.7, Windows/PowerShell, logiczny viewport 640x360, projekt bez Git.
Getting Strange jest grą w Godot 4.7 i niczym innym. Nie twórz ani nie
przywracaj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor,
Androida, Gradle, Google Play ani innej powierzchni dystrybucji poza silnikiem
Godot. Nie uruchamiaj Git.

Pierwszą bramką jest:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Zapisz wynik baseline przed edycją i uruchom tę samą bramkę po zamknięciu
pakietu. Nie zmieniaj timeoutów, workerów, retry, progów ani zakresu
istniejących testów tylko po to, żeby uzyskać PASS.

## TOŻSAMOŚĆ PAKIETU

Jesteś Lead Programmerem i Art Directorem projektu. Wykonaj pakiet
autonomicznie, krok po kroku, bez pytania o zgodę i bez zatrzymywania pracy
dla ręcznego review. Każdy ukończony etap zapisz natychmiast na dysku.
Decyzje podejmuj na podstawie aktualnego runtime’u, kanonu, lokalnych skilli
i dowodów z pomiaru.

## STAN PO PKG-0107

- Pełny verify oraz bramka `tests/pkg_0107_smoke_test.gd` przechodzą.
- Station 42A, 42B, 42C i 43 mają widoczne, deterministyczne profile
  `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox` i
  `OpeningDialogueCue`; cztery kadry 640x360 znajdują się w
  `reports/pkg_0107/` i zostały obejrzane technicznie.
- `docs/TRAVERSAL_ACT_IV_FINAL_AUDIT.md` ustanawia świadomą ciszę finałów:
  łączny budżet nowych przeszkód PKG-0107 wynosi 0. Nie zmieniaj colliderów,
  fizyki, logiki kampanii, flag, kosztów, dialogów, limitu 25 ani schematu
  zapisu 1.
- H-012 pozostaje `UNTESTED`. Dotychczasowe kadry dowodzą obecności
  kompozycji i drogi, ale nie zawierają pomiaru kontrastu, skalowania 1x–4x
  ani symulacji deuteranopii/protanopii. Nie awansuj hipotezy automatycznie.
- Znane ostrzeżenia o `ObjectDB`/`RID leak` przy zamykaniu Godota są szumem
  istniejącym w poprzednich przebiegach; sprawdź, czy kod wyjścia nadal jest 0.

## OBOWIĄZKOWA KOLEJNOŚĆ PRACY

### 1. Start i lektura

W katalogu `C:\getting_strange` przeczytaj w tej kolejności:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. ten plik `docs/NEXT_SESSION_PROMPT.md`;
5. aktywną specyfikację wskazaną w `CURRENT_STATE.md`, w szczególności
   `VISUAL_DESIGN.md` i `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
6. `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i
   `docs/WORKFLOW.md`;
7. `docs/TRAVERSAL_ACT_IV_FINAL_AUDIT.md`,
   `tests/pkg_0107_smoke_test.gd`, `tools/capture_pkg_0107.gd` oraz źródła
   `VectorStageEnvironment`, `VectorStageStyle`, `AtmosphereRig` i sceny
   reprezentatywne dla audytu.

Następnie uruchom baseline `tools/verify.ps1` i zapisz wynik przed pierwszą
edycją.

### 2. Zdefiniuj pomiar, zanim zmienisz kod

Zapisz read-only plan audytu, obejmujący co najmniej:

- zestaw reprezentatywnych kadrów z początku, środka, mechanicznego plasterka
  i finałów, w tym świeże 42A, 42B, 42C oraz 43;
- elementy mierzone osobno: droga przejścia, materialny akcent korekty,
  punktowy akcent stanu, napis/ramka CRT, granica planu i sylwetka postaci;
- pomiar rozmiaru w pikselach i położenia, kontrastu względem sąsiedniego
  planu oraz odróżnialności od tła, z podaniem metody i jednostek;
- zachowanie obrazu przy logicznym 640x360 oraz całkowitym skalowaniu 1x, 2x,
  3x i 4x bez filtrowania, jeśli sterownik na to pozwala;
- wariant oryginalny, grayscale oraz symulacje deuteranopii i protanopii,
  wyraźnie oznaczone jako transformacje techniczne, nie jako badanie osób;
- regułę klasyfikacji wyniku i ograniczenia. Nie wymyślaj progu, którego nie
  da się uzasadnić specyfikacją; brak obiektywnego rozstrzygnięcia oznacza
  pozostawienie H-012 jako `UNTESTED`.

### 3. Wykonaj audyt deterministycznie

Możesz dodać narzędzie pod `tools/` i raport pod `docs/`, a wygenerowane PNG
i warianty umieść w `reports/pkg_0108/`. Preferuj istniejący kontrakt capture
i normalny sterownik Windows/OpenGL. Narzędzie ma:

- działać bez zmiany logiki gry, colliderów, scen finałowych, InputMap,
  fizyki 60 Hz, limitu kampanii 25 i `SAVE_SCHEMA_VERSION = 1`;
- zapisywać konfigurację, rozdzielczość, skalę, źródło kadru, metodę
  transformacji i wynik, tak aby kolejna sesja mogła powtórzyć pomiar;
- odróżniać pomiar obecności/kontrastu/rozmiaru od twierdzeń o czytelności
  przez człowieka, funie, emocji lub zrozumieniu fabuły;
- mieć test lub bramkę tylko wtedy, gdy chroni stabilny kontrakt techniczny.
  Nie osłabiaj istniejących bramek i nie traktuj samego istnienia pliku PNG
  jako dowodu pomiaru.

Jeżeli konieczna okaże się korekta artystyczna, ogranicz ją do minimalnej,
udokumentowanej poprawy warstwy Vector-Stage. Nie dodawaj przeszkód dla
wypełnienia kadru, nie twórz platformingu i nie zmieniaj mechaniki. Każdą
zmianę porównaj ze świeżym pomiarem przed i po.

### 4. Zinterpretuj wynik ostrożnie

Raport musi rozdzielać: obserwację z pliku, wynik obliczenia, decyzję
produkcyjną i nierozstrzygniętą hipotezę. Cztery świeże kadry finałów są
wyłącznie dowodem technicznym: nie zapisuj, że ktoś je zrozumiał albo że gra
jest czytelna dla nowej osoby. H-012 może pozostać `UNTESTED`, jeśli pomiar
nie obejmuje całego wymaganego kontraktu albo wynik jest niejednoznaczny.

### 5. Zaktualizuj stan i przygotuj następny handoff

Po zakończeniu audytu zaktualizuj zgodnie z faktem:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` z jednym wpisem `PKG-0108`;
- `docs/RISKS_AND_HYPOTHESES.md` bez awansowania H-012 ponad dowód;
- `docs/ROADMAP.md`, `docs/DECISION_LOG.md` tylko jeśli decyzja rzeczywiście
  zmieniła status lub kontrakt;
- `docs/INDEX.md`, jeśli powstał nowy żywy audyt;
- ten plik, zastępując go kolejnym samodzielnym promptem po zamknięciu
  pakietu.

## KRYTERIA AKCEPTACJI

Pakiet jest technicznie zamknięty dopiero, gdy:

1. baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` przechodzą;
2. istnieje żywy raport audytu z metodą, danymi, źródłami kadrów, skalami,
   transformacjami i ograniczeniami;
3. istnieje powtarzalne narzędzie lub zapisany skrypt pomiarowy, jeśli audyt
   wymagał obliczeń poza ręcznym obejrzeniem;
4. świeże kadry i warianty techniczne zostały obejrzane, a dokumentacja nie
   zawiera twierdzeń o playtestach ani odbiorze człowieka;
5. kod gry nie narusza zakresu Godot-only, nie używa Git i zachowuje wszystkie
   istniejące kontrakty kampanii, traversal i zapisu;
6. `CURRENT_STATE.md`, `SESSION_LOG.md`, hipotezy, indeks i następny prompt
   odpowiadają dokładnie plikom na dysku;
7. snapshot zostanie wykonany jako `PKG-0108` po końcowym PASS.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Na końcu uruchom końcowy verify, zapisz jego wynik, wykonaj:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0108
```

Sprawdź istnienie snapshotu, ale nie edytuj ani nie traktuj jego kopii jako
bieżącego stanu. Raport końcowy ma wymienić wykonane testy, świeże pomiary,
ograniczenia, status H-012, pakiet wpisany do `SESSION_LOG.md` oraz ścieżkę
handoffu. Nie kończ pracy przed aktualizacją dokumentacji i snapshotem.
