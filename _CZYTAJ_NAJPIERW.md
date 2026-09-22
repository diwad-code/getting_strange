# Zawartość archiwum — audyt fabularny „Getting Strange”

Struktura katalogów odpowiada projektowi (`C:\getting_strange`). Wycięto wyłącznie
pliki towarzyszące Godota (`*.uid`, `*.import`), które nie niosą treści.

## docs/narrative/ — kanon fabularny (priorytet 1)
- `FULL_STORY.md` — pełny przebieg. **Uwaga:** sekcje numerowane 19+ opisują
  wycofanego dawcę 0.3, a nie aktywną trasę kampanii.
- `NARRATIVE_BIBLE.md` — tożsamość opowieści, postacie, relacje.
- `DIALOGUE_SCRIPT.md` — zasady dialogu, głosy, agendy, progi wiedzy.
- `CONTINUITY_TRACKER.md` — ciągłość faktów: kto co wie i od kiedy.

## docs/rebuild/ — kontrakty produktu (priorytet 1)
- `CAMPAIGN_MAP.md` — mapa 20 adresów, cele, rodziny miejsc, zmiana pytania.
- `PLAYER_CONTRACT.md` — kim jest gracz, stawka, stan wiedzy po 1/5/30 min.

## scripts/ — runtime (priorytet 2, źródło prawdy dla tekstu)
- `levels/creative_scene_lines.gd` — **główna baza dialogów stacji 09–18**
  (słownik `LINES`, fallbacki, bramka wiedzy `world_recognized`).
- `levels/creative_scene_presentation.gd` — kolejkowanie rozmów, wiązanie
  kwestii z czynnościami gracza, blokada na winietach.
- `levels/station_01.gd` … `station_18.gd` — **stacje 01–08 mają kwestie
  wpisane inline w skrypcie**; każdy plik otwiera nagłówek
  `## PRZESZKODA — dlaczego to tu jest / czego wymaga od Leny / koszt porażki`.
- `levels/station_42a.gd`, `42b`, `42c`, `station_43.gd` — trzy warianty
  finału i epilog (stałe `DIALOGUE_LINES`).
- `ui/cold_open.gd` — trzy ujęcia otwarcia, zero tekstu ekspozycyjnego.
- `campaign/cold_open_facts.gd` — pięć faktów otwarcia + dozwolone i zakazane
  nośniki.
- `campaign/gap_ledger.gd` — katalog luk: co blokują i jaką myślą Leny są
  nazwane.
- `core/game_state_manager.gd` — `CAMPAIGN_ROUTE`, finały, epilog, kierunki
  wejść, progi, bramki postępu.
- `core/narrative_guidance_service.gd`, `core/guidance_beat.gd` — system
  wewnętrznego głosu, poziomy L0–L4, hipotezy i ich zamykanie.

## scenes/levels/ — 45 scen `*.tscn`
Geometria i rekwizyty. **Aktywna trasa to tylko** `station_01` … `station_18`,
`station_42a/b/c`, `station_43`. Pliki `station_19` … `station_41` to zamrożony
dawca legacy — nie są adresami kampanii i nie należy ich audytować jako etapów.

## resources/gameplay/ — 15 plików `*.tres`
Sekwencje dramatyczne zapisane jako dane.

## Aktywny przebieg
```
COLD OPEN → stacje 01–18 (liniowo) → jeden wariant 42A/42B/42C → epilog 43
```
20 odwiedzanych adresów. Postęp zawsze w prawo albo w górę; powrót w lewo albo
w dół. Dwa fabularne powroty wchodzą z prawej: 12→13 oraz 17→18.
