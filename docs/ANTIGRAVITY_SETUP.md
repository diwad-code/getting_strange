# Konfiguracja Antigravity CLI dla Getting Strange (zgodność z OpenCode CLI)

Stan na: 2026-09-16. Zmiana toolingowa na jawne zlecenie użytkownika (wyrównanie środowiska
Antigravity CLI do OpenCode CLI). Nie konsumuje numeru PKG, nie modyfikuje kodu gry
(`scenes/`, `scripts/`, `tests/`), handoff pozostaje nienaruszony.

---

## 1. Serwery MCP (1:1 z OpenCode CLI)

W OpenCode CLI aktywne są dokładnie 3 serwery MCP (`opencode mcp list`):
1. `godot` (lokalny stdio): `npx -y godot-mcp-runtime`
   - Środowisko:
     - `GODOT_PATH`: `C:\Users\admin\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe`
     - `GODOT_MCP_DISABLE_ELICITATION`: `true`
2. `context7` (zdalny HTTP): `https://mcp.context7.com/mcp`
3. `gh_grep` (zdalny HTTP): `https://mcp.grep.app`

### Zmiany w Antigravity (`~/.gemini/config/mcp_config.json`):
- Skonfigurowano serwer `godot` na identyczny runtime `npx -y godot-mcp-runtime` z tą samą ścieżką do silnika i flagą pomijania elicytacji (wcześniejszy wpis wskazywał na nieistniejący plik).
- Dodano serwery HTTP `context7` i `gh_grep`.
- Wyłączono (`"disabled": true`) pozostałe serwery niezwiązane z projektem (Hostinger API, Data Cloud, Notebooks, Chrome DevTools, Sequential Thinking), eliminując błędy schematów narzędzi i doprowadzając listę aktywnych MCP do stanu identycznego jak w OpenCode.

Zweryfikowano poleceniem: `agy mcp list`.

---

## 2. Komendy slash (odpowiedniki `.opencode/commands/`)

Utworzono dedykowaną wtyczkę `getting-strange` w `~/.gemini/config/plugins/getting-strange/`
zarejestrowaną w `import_manifest.json` oraz `config.json`.

Dostępne komendy slash w Antigravity CLI:
- `/verify` — pełna weryfikacja projektu (124 bramki headless + polityka logów).
- `/verify-scoped <skrypty>` — weryfikacja zawężona D-217 (docs + bramki pojedynczo przez `run_gate.ps1`).
- `/verify-docs` — szybki test kontraktu dokumentacji (52 pliki).
- `/gate <ścieżka_res>` — uruchomienie pojedynczej bramki z limitem linii wyjścia.
- `/capture [flagi]` — zrzut kadrów normalnym sterownikiem graficznym (`tools/capture_preview.gd`).
- `/snapshot <PKG-NNNN>` — zamrożenie pakietu w `snapshots/`.
- `/pkg-start` — procedura startu sesji i checklisty czytania.
- `/pkg-close` — procedura domknięcia pakietu, aktualizacji handoffu i zamrożenia.

---

## 3. Umiejętności (Skills)

- Skopiowano umiejętność cyklu życia pakietu `getting-strange-pkg` do:
  - `.agents/skills/getting-strange-pkg/SKILL.md`
  - `.agent/skills/getting-strange-pkg/SKILL.md`
- Ponad 60 umiejętności silnikowych `godot-*` w `.agents/skills/` jest automatycznie wykrywanych przez silnik umiejętności Antigravity.

---

## 4. Agenci i subagenci (odpowiedniki `.opencode/agents/`)

Zarejestrowano subagenty wyspecjalizowane w zadaniach Getting Strange:
- `godot-build`: Główny programista Godot 4.7 (implementacja mega-pakietów 2x-5x, D-085, D-217, pełny dostęp do zapisu).
- `godot-plan`: Architekt i analityk w trybie tylko do odczytu (`edit: deny`), tworzący plany implementacji bez modyfikacji plików.
- `godot-verify`: Dedykowany wykonawca bramek weryfikacyjnych raportujący wyniki i naruszenia log policy.
- `godot-visual`: Inspektor kadrów graficznych ze sterownikiem okienkowym (zakaz trybu headless).

---

## 5. Granice uprawnień i bezpieczeństwo

W `~/.gemini/antigravity-cli/settings.json` dodano twarde reguły zabraniające:
- `command(git*)`
- `command(gh*)`
- `command(rm -rf*)`

Odzwierciedla to regułę z `opencode.json` wymuszającą brak kontroli wersji (brak undo, dysk jako jedyny stan prawdy).
W `~/.gemini/config/config.json` dodano uprawnienia dla narzędzi `mcp(godot)`, `mcp(context7)`, `mcp(gh_grep)` oraz operacji na katalogu `C:\getting_strange`.
