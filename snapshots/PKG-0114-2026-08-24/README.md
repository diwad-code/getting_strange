# Getting Strange

`Getting Strange` to jednoosobowa, narracyjna gra 2D w Godot 4.7 o
rzeczywistości, która retrospektywnie poprawia ludzi i miejsca niezgodne z jej
dominującą wersją. Projekt obejmuje wyłącznie grę Godot na PC; nie ma wariantu
webowego ani mobilnego.

Projekt jest w fazie **P4: produkcja, szlif i przygotowanie do wydania**. Kod i
sceny zawierają 43 przestrzenie kampanii, trzy warianty finału, epilog,
Zakotwiczenie/Uległość, lokalny zapis, menu pauzy, dialog CRT, proceduralne
audio oraz autorską oprawę Rówień Vector-Stage. To nie oznacza jeszcze
gotowości do publikacji.

## Uruchomienie robocze

Wymagany jest Godot `4.7.x`.

```powershell
godot --editor --path C:\getting_strange
```

```powershell
godot --path C:\getting_strange
```

Punkt wejścia projektu wskazuje produkcyjny shell
`scenes/shell/title_screen.tscn`. `NOWA GRA` otwiera Station 01, a
`KONTYNUUJ` korzysta z prawidłowego zapisu kampanii. Movement Lab i Anchor Lab
pozostają narzędziami deweloperskimi, nie ekranem startowym produktu.

Sterowanie runtime:

- `A` / `D` lub lewy analog: ruch;
- `Spacja` lub dolny przycisk pada: skok;
- `E` lub zachodni przycisk pada: interakcja;
- `F` lub północny przycisk pada: wymuszenie korekty w scenach testowych;
- `R`: restart;
- `Esc`: pauza.

## Weryfikacja

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Obowiązkowa bramka sprawdza kontrakt dokumentacji, import Godot, semantyczny
InputMap, fizykę ruchu, zakazy przeszkód oraz testy pakietowe. Główny smoke test
wywołuje obecnie wszystkie 43 przestrzenie kampanii, w tym warianty 42A–42C i
epilog 43. Automaty potwierdzają kontrakty techniczne; nie dowodzą funu,
czytelności przez nową osobę ani odbioru emocjonalnego.

## Stan gotowości wydawniczej

Najważniejsze otwarte blokery to:

- pełna klawiatura/pad, remap, skala tekstu, lokalizacja PL/EN i dostępność;
- `export_presets.cfg`, buildy Windows/Linux i test czystej instalacji;
- content lock, credits/licencje, clearance tytułu i pakiet wydawniczy;
- dalszy ręczny szlif najbardziej generycznych kadrów Vector-Stage.

Techniczna trasa kampanii jest spięta: 01..41 prowadzi do dokładnie wybranego
42A/42B/42C, każdy wariant prowadzi do 43, a epilog wraca do menu z zachowanym
zapisem. Nie oznacza to jeszcze gotowości wydawniczej.

Pełna macierz dowodów i kolejność domknięcia znajdują się w
[`docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md`](docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md).

## Dokumentacja

Nowa sesja zaczyna od:

1. [Indeks dokumentacji](docs/INDEX.md)
2. [Aktualny stan](docs/CURRENT_STATE.md)
3. [Prompt następnej sesji](docs/NEXT_SESSION_PROMPT.md)
4. aktywna specyfikacja wskazana w `CURRENT_STATE.md`

Kierunek i proces:

- [Roadmapa](docs/ROADMAP.md)
- [Kierunek techniczny](docs/TECHNICAL_DIRECTION.md)
- [Kanon wizualny](VISUAL_DESIGN.md)
- [Kanon przeszkód](docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md)
- [Ryzyka i hipotezy](docs/RISKS_AND_HYPOTHESES.md)
- [Workflow pakietów](docs/WORKFLOW.md)
- [Rejestr decyzji](docs/DECISION_LOG.md)
- [Dziennik pakietów](docs/SESSION_LOG.md)

Projekt nie używa systemu kontroli wersji. Pliki na dysku są jedynym stanem,
a zamknięte pakiety są zamrażane przez `tools/snapshot.ps1`.
