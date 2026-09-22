# Rejestr hipotez — panel playtest_panel_2026-09-03 (PKG-0186)

Status: Faza A (odczytowa). Źródło: `playtest_panel_2026-09-03/PANEL_REPORT.md`
§3, §5, §7, §8 oraz `brief.md`. Panel jest syntetyczny (fidelity: description,
0 person obsłużyło build) — każdy wiersz to HIPOTEZA do weryfikacji w Fazie B,
nie fakt o graczach. Startowy warunek pakietu (PKG-0184 zamknięty: raport,
`reports/pkg_0184/`, snapshot `snapshots/PKG-0184-2026-09-04/`, wpisy w
`SESSION_LOG.md`) — spełniony. Aktywny handoff `docs/NEXT_SESSION_PROMPT.md`
wskazuje PKG-0185 (owner-gated release/P3), inny pakiet niż ten — zgodnie z
promptem. Uruchomienie tego pakietu potraktowane jako `jawna dyspozycja
właściciela` przez bezpośrednie polecenie „Wykonaj prompt:
docs/PLAYTEST_PANEL_FIXES_PROMPT.md” — nie jest to GATE-REL ani P3 backlog,
więc numer pakietu to **PKG-0186** (kolejny wolny po PKG-0185, który zostaje
zarezerwowany dla release/P3), żeby nie kolidować z zarezerwowanym slotem.

Ważne: PKG-0184 (2026-09-04, dzień wcześniej niż ten pakiet, na tym samym
niezmienionym kodzie zimnego otwarcia i etykiet menu) już zbadał leady 2 i 5
niezależnie (`reports/pkg_0184/final_defect_register.tsv` F-0184-014,
F-0184-015). Ten rejestr cytuje te ustalenia zamiast je duplikować i dodaje
własną weryfikację dla leadów, których PKG-0184 nie dotknął.

## Tabela hipotez

| ID | Źródło (osoby/sekcje) | Pewność panelu | Twierdzenie (forma weryfikowalna) | Metoda weryfikacji (Faza B) | Propozycja poprawki / zakres plików | Klasyfikacja |
|---|---|---|---|---|---|---|
| L01 | §3.1, §8.1 — p01,p02,p04,p07,p12,p15,p16,p19 (+częściowo p03,p09) | M | Warstwa A zimnego otwarcia jest w buildzie niepomijalna przy pierwszym uruchomieniu I nie ma udokumentowanego czasu trwania. | Inspekcja `scripts/ui/cold_open.gd` (`_can_skip`, `is_cold_open_seen()`), `scripts/core/game_state_manager.gd` (`mark_cold_open_seen`), pomiar `SHOT_SECONDS` sumy. | Brak — jeśli CONFIRMED że skip istnieje dopiero po 1. ukończeniu, to jest already BY-DESIGN (D-195); ewentualnie tylko dokumentacyjne dopisanie czasu trwania do `CURRENT_STATE.md`. | gameplay UI |
| L02 | §3.2, §5, §8.2 — p01,p03,p04,p06,p08,p09,p10,p11,p17,p18 | M(percepcja)/L(defekt) | Po kliknięciu NOWA GRA ekran jest w pełni czarny bez żadnego sygnału (ładowanie/podpis ujęcia) dłużej niż zamierzony fade. | Inspekcja `transition_to_scene()` (fade 0.22s+0.28s); ponowne wykorzystanie pomiaru PKG-0184 (`cold_open__t0.png`/`initial.png`, mean luma 0.1024, `reports/pkg_0184/visual_matrix.tsv`) — kod niezmieniony od 2026-09-04. | Jeśli REFUTED (fade zamierzony, krótki) — brak zmiany kodu; jeśli CONFIRMED realny brak sygnału w pierwszej klatce ujęcia 1 — natychmiastowy podpis ujęcia/element świata (bez wykładu/loading screen), p. Faza D reguła 2. | UI shell |
| L03 | §3.3, §5, §8.3 — 17/20 partial Q2; p09,p10,p18 (wskaźnik niewidoczny w dialogu) | M | W Station 01 brak widocznego w interfejsie sygnału „krok ukończony → następny krok”, w tym podczas okna dialogu. | Inspekcja `scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn` — węzeł celu, z-order dialogu vs goal UI. | Element interfejsu stacji, ostry tekst, bez nagłówka tutorialowego (Faza D reguła 3). Pliki: `scripts/levels/station_01.gd`, ew. wspólny UI celu jeśli współdzielony. | gameplay UI |
| L04 | §3.4, §8.4 — p01,p08,p09,p18 | H (widoczne na zrzutach) | Metadane techniczne/żargon inżynierski są widoczne na produkcyjnych powierzchniach (ekran tytułowy, HUD) poza trybem deweloperskim. | Grep `BUILD_LABEL`, `CRT_CHANNEL`, „(DEBUG)”, „KANAŁ PRODUKCYJNY” w żywym `scripts/`/`scenes/`; ustalenie czy `CRT_CHANNEL` jest diegetyczny. | Jeśli CONFIRMED (np. `BUILD_LABEL` zawsze widoczny) — schowanie za tryb deweloperski/panel pomocy, bez usuwania z raportów (Faza D reguła 4). Plik: `scripts/ui/title_screen.gd`. | UI shell |
| L05 | §3.5, §5, §8.5 — p18 | likely (defekt dokumentacji) | Etykiety menu w opisie (`brief.md`: Nowa gra/Wczytaj/Ustawienia/Wyjście) różnią się od builda. | Grep `MENU_NEW_GAME`/`MENU_CONTINUE`/`MENU_SETTINGS`/`MENU_QUIT` w żywym `localization_manager.gd`; porównanie z PKG-0184 F-0184-015 (już CLOSED-NOT-A-BUILD-DEFECT). | Brak zmiany kodu gry; `brief.md` panelu jest zamrożonym artefaktem dowodowym, nie kanonem — nie nadpisywać. | dokumentacja (poza zakresem kodu) |
| L06 | §5 — p03(guess), p07, p11(possible) | guess/possible | Kadry dialogu b2 i b3 są obrazowo identyczne (artefakt eksportu vs defekt logiki dialogu). | Szukanie plików dowodowych „b2”/„b3” na dysku; jeśli brak — nie da się zweryfikować bez świeżego capture. | Zależne od wyniku; niska waga (severity low, confidence possible/guess). | gameplay UI / poza zakresem jeśli brak materiału |
| L07 | §5 — p13 | possible | Status zapisu „ZAPIS: BRAK PRAWIDŁOWEGO STANU” jest dwuznaczny (miesza „brak zapisu” i „stan nieprawidłowy”). | Grep `STATUS_SAVE_NONE`/`STATUS_SAVE_ACTIVE` w żywym `localization_manager.gd`. | Zależne od wyniku — jeśli tekst już nie istnieje w żywym kodzie, REFUTED bez zmian. | UI shell |
| L08a | §7 — Barbara | brak (accessibility sweep, nie zweryfikowane) | Blok sterowania na ekranie tytułowym ma mały, niski kontrast. | Odczyt kolorów/rozmiaru fontu bloku sterowania w `scripts/ui/title_screen.gd` (VectorStageStyle shade/alpha) vs próg WCAG AA orientacyjnie. | Jeśli CONFIRMED — podniesienie kontrastu/rozmiaru w obrębie istniejącego stylu (VectorStageStyle), bez zmiany układu. | UI shell / accessibility |
| L08b | §7 — Barbara, Viktor | brak | Brak podpowiedzi klawisza przy INTERAKCJA w scenie (strefy `interact`). | Grep „interact” w `scripts/ui/`, `scripts/campaign/`, `scripts/levels/station_01.gd` — czy istnieje prompt UI przy strefie. | Jeśli CONFIRMED brak — dodanie krótkiego podpisu klawisza przy wejściu w zasięg strefy (bez nowego czasownika/przycisku). | gameplay UI / accessibility |
| L08c | §7 — Barbara, Chris | brak | Scena Station 01 jest ciemna i nisko kontrastowa. | Pomiar luma/kontrastu kluczowych par kolorów Station 01 (droga przejezdna vs tło) wg §7.4 kanonu przeszkód (`TRAVERSAL_AND_OBSTACLE_DESIGN.md`). | Tylko obiektywny pomiar — bez „poprawiania piękna”; zmiana tylko jeśli kontrast łamie już istniejący kontrakt §7.4 (droga ma mieć najwyższy kontrast w kadrze). | wizualne / accessibility |
| L08d | §7 — Barbara | brak | Żargon techniczny bez wyjaśnienia (nakłada się z L04). | Cross-ref L04. | Brak osobnej poprawki — pokryte przez L04. | duplikat L04 |
| L08e | §7 — George, Kenji | brak | SKOK opisany słowem, nie funkcją/ikoną w UI/ustawieniach. | Grep „SKOK”/„JUMP” w `localization_manager.gd` i UI rebindu/ustawień. | Jeśli CONFIRMED i w zakresie (bez zmiany mechaniki/InputMap) — kosmetyczna zmiana etykiety/ikony w panelu rebindu. | UI shell / accessibility |
| L09 | §3.6, §3.7, §6, §8.6, §8.7 — p05,p07,p13,p14,p16,p19,p20 (Ahmed mobile-only) | L (persona-relatywne) | Brak co-op/share, brak pętli opartej o skill/liczby, blocker mobile-only, brak trybu łagodzenia napięcia, brak jawnej deklaracji „solo/PC-only” w materiałach. | Brak — świadomy zakres produktu (gra solowa, PC/Linux, bez arcade, bez liczbowego kodeksu Anchor/Yield na tym etapie; brak powierzchni webowej/marketingowej w tym projekcie — `AGENTS.md` zakaz web). | Brak wdrożenia w tym pakiecie. | `WONTFIX-SYNTHETIC` — kontrakt produktu (gra solowa kameralna, Godot-only, bez arcade/liczbowego UI Anchor-Yield na tym etapie; materiały marketingowe poza zakresem Godot-only) |

## Uwaga o L06/L07

L06 i L07 mają w panelu confidence `guess`/`possible` i `possible` — najniższe
w całym materiale. Faza B rozstrzygnie je przez odczyt kodu/dysku, nie przez
spekulację. Brak materiału dowodowego na dysku dla L06 będzie odnotowany
wprost jako `NIEREPRODUKOWALNE-BEZ-CAPTURE`, nie jako `REFUTED` — brak dowodu
nie jest dowodem nieobecności, ale bez artefaktu obrazu nie da się policzyć
MD5 ani nie da się bezpiecznie stwierdzić defektu logiki dialogu.

## Uwaga o L05

`docs/CURRENT_STATE.md` i inna aktywna dokumentacja kanonu **nigdy nie
opisywały** etykiet „Wczytaj/Wyjście” — ten opis istnieje wyłącznie w
zamrożonym `playtest_panel_2026-09-03/brief.md` (artefakt panelu, dowód
historyczny). Reguła Fazy D „popraw dokumentację do stanu builda” nie ma tu
zastosowania, bo żaden żywy dokument kanonu nie jest w rozjeździe — zgodnie z
ustaleniem PKG-0184 (F-0184-015).
