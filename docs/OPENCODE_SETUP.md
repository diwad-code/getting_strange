# Konfiguracja OpenCode dla Getting Strange

Stan na: 2026-09-13. Zmiana toolingowa na jawne zlecenie użytkownika (pierwszeństwo
nad promptem i roadmapą, `docs/WORKFLOW.md`). Nie jest to pakiet gry: nie konsumuje
numeru PKG, nie rusza `scenes/`/`scripts/`/`tests/`, nie zmienia handoffu
(`CURRENT_STATE.md`, `NEXT_SESSION_PROMPT.md`, `SESSION_LOG.md` nietknięte).
Snapshot nie dotyczy tej zmiany (`tools/snapshot.ps1` zamraża tylko
`scenes/`, `scripts/`, `tests/`).

## Co utworzono

- `opencode.json` — konfiguracja projektu: `shell: powershell`, auto-ładowane
  instrukcje (`AGENTS.md`, `docs/WORKFLOW.md`,
  `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`, `VISUAL_DESIGN.md`, ten plik),
  ignorowane w watcherze `.godot/`, `reports/`, `snapshots/`, `dist/`, `*.log`,
  `snapshot: false` (projekt nie ma Gita; zamrożeniem jest `tools/snapshot.ps1`),
  `lsp: false` (diagnostyką są bramki Godota, nie serwer językowy),
  uprawnienia bash: wszystko dozwolone poza `git`/`gh`/`rm -rf` (reguła no-Git
  wyegzekwowana także konfiguracyjnie; ostatnia reguła wygrywa, więc deny stoją
  po `*`), `external_directory: ask`.
- MCP `godot` (`npx -y godot-mcp-runtime`, MIT): wybrany, bo działa bez
  commita addona do repo (przejściowy autoload, sprzątany przy zamknięciu) —
  inne serwery Godot MCP wymagają wpiętego addona, co brudziłoby pinowane drzewo
  projektu. Daje inspekcję projektu/scen/skryptów, `run_project` z mostem live
  (screenshoty, symulacja inputu, żywy GDScript, drzewo sceny) oraz bramkę
  statyczną Tier-1 (twarde bloki destrukcji). `GODOT_MCP_DISABLE_ELICITATION`
  jest włączone, więc potwierdzenia nie blokują pracy autonomicznej (Lead
  Programmer); bloki Tier-1 nadal obowiązują. `GODOT_PATH` wskazuje jawnie
  Godota 4.7.2 z WinGet.
- MCP `context7` (remote): dokumentacja poza cutoff. Wołać dopiskiem
  `use context7`; bez klucza limity są niższe (`CONTEXT7_API_KEY` opcjonalnie).
- `.opencode/agents/`: `godot-build` (primary, pełny PKG), `godot-plan`
  (primary, read-only: `edit: deny`), `godot-verify` (subagent bramek),
  `godot-visual` (subagent kadrów normalnym sterownikiem).
- `.opencode/commands/`: `/verify` (pełna, 124 bramki), `/verify-scoped`
  (docs + bramki po jednej przez `run_gate.ps1`, z pominięciem pułapki wiązania
  `@(...)` przez `pwsh -File`), `/verify-docs`, `/gate`, `/capture` (nigdy
  headless — wiesza się na `frame_post_draw`), `/snapshot`, `/pkg-start`,
  `/pkg-close`.
- `.opencode/skills/getting-strange-pkg/SKILL.md` — cykl pakietu w pigułce
  (start, mega-pakiet, D-217, zamknięcie). Odkrywany przez narzędzie `skill`.
- `.opencode/tools/godot-gate.ts` — narzędzie do jednej bramki (omija cytowanie
  PowerShella przez `Bun.spawnSync` na `tools/run_gate.ps1`). Duplikuje je
  komenda `/gate`, więc awaria ładowania narzędzia nie blokuje pracy.
- `.opencode/.gdignore` (pusty) — Godot ignoruje cały `.opencode/`, tak jak
  `skills/` (reguła z `AGENTS.md` rozszerzona na nowy katalog narzędzi).
- Umiejętności Godot (60+, `godot-*`) były już w `.agents/skills/` i są
  auto-odkrywane przez OpenCode — niczego nie duplikowano.

## Wymagania (zweryfikowane na tej maszynie)

- `opencode` 1.18.30, `node` v26 / `npx` / `bun` 1.3.13, `godot` 4.7.2 na PATH.
- Pierwsze `opencode mcp list` dociąga `godot-mcp-runtime` przez npx (raz).

## Dowody (2026-09-13, pliki gry nietknięte)

- `opencode debug config` — scala `opencode.json` (instrukcje, watcher,
  uprawnienia, oba MCP).
- `opencode mcp list` — `godot connected`, `context7 connected`
  (`android-mcp` globalny, disabled, nieruszony).
- `opencode debug skill` — `getting-strange-pkg` odkryty z
  `.opencode/skills/getting-strange-pkg/SKILL.md`.
- `opencode debug agent godot-build` — agent ładuje się (primary, uprawnienia
  projektowe). Pierwsze wywołanie wolne (dociąganie narzędzi MCP), kolejne
  szybkie.
- `tools/verify_docs.ps1` — `DOCS PASS: 52 required files and handoff contracts`.
- `run_gate.ps1 res://tests/smoke_test.gd` — `SMOKE PASS`, exit 0.
- `run_gate.ps1 res://tests/pkg_0207_gate_census_test.gd` —
  `117 invokes / 116 scripts / 115 tests`, PASS (pin nietknięty).
- `godot --headless --editor --path . --quit` — exit 0 (nowe pliki nie psują
  importu). Pełne `tools/verify.ps1` (124 bramki) celowo nieuruchomione:
  zmiana nie dotyka kodu gry, a smoke + pin + import + docs pokrywają blast
  radius (same nowe pliki konfiguracyjne).

## Ograniczenia i kolejne kroki

- Załadowanie `godot-gate.ts` POTWIERDZONE: OpenCode sam dopisał
  `.opencode/package.json` (`@opencode-ai/plugin` w wersji CLI), `package-lock.json`
  i `node_modules/` — import narzędzia ma z czego się rozwiązać. (Wcześniejszy
  błąd `bun build` poza runtime OpenCode był spodziewany, nie jest błędem.)
  Fallback na wypadek problemów: komenda `/gate` robi to samo.
- Narzędzia live MCP (`run_project` i okolice) wymagają uruchomionej gry;
  testy dowodzą kontraktów, nie odbioru (D-012, ADR-003).
- `.agents/skills/` nie ma `.gdignore`, więc Godot importuje setki `.md` jako
  zasoby — działa, ale spowalnia import. Kandydat na osobny pakiet toolingowy.
- Globalny `~/.config/opencode/opencode.jsonc` zostawiono jak był (tylko
  `shell`); całość konfiguracji projektu mieszka w repo.
