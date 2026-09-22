# ADR-008: Hybrid product rebuild after board-level greenlight audit

## Status

Accepted

## Date

2026-08-31

## Context

PKG-0154 zamknął P8 technicznie: bieżące buildy Windows/Linux, shell, zapis,
kontynuacja, routing, 45 scen technicznych i kontrakty P7 przechodzą automatyczne
bramki. Ten stan nie rozstrzyga jakości doświadczenia.

Właściciel przekazał wiążącą diagnozę runtime:

1. gracz nie wie, kim jest;
2. gracz nie wie, co ma robić;
3. gracz nie wie, po co ma to robić;
4. gracz nie rozumie zasad świata;
5. lokacje wyglądają zbyt podobnie;
6. rodziny przestrzeni są wizualnie nierozróżnialne;
7. gra nie komunikuje się poprawnie jako doświadczenie.

Audyt `docs/PROJECT_REBUILD_BOARD_PROMPT.md` skonfrontował te fakty z runtime,
źródłami, dokumentacją i reprezentatywnymi capture'ami. Ujawnił silny szkielet
techniczny, ale słaby produkt: 45 scen dzieli pełny wspólny scaffold, bieżący
`VectorStageEnvironment` koduje wszystkie rodziny miejsc, a
`MemoryResonancePoint` przekroczył 10 tysięcy linii i sprowadza ponad 200 typów
obiektów do podobnego modelu aktywacji. 43-adresowy obowiązek mnoży powtórzenia.

## Decision

Wybieramy `HYBRID_REBUILD` i greenlight `GO WITH HARD PIVOT`.

Zachowujemy sprawną technologię Godot 4.7: InputMap, fizykę gracza, Lenę 4.1,
shell, ustawienia, save/load, pauzę, lokalizację, kamerę, compositor Pixel-Stage,
ostre teksty, proceduralne audio, techniczny rdzeń Anchor/Yield, test runner i
workflow eksportu.

Przepisujemy produkt:

- opening i pierwsze 30 minut;
- hierarchię informacji;
- runtime dialogue i staging relacji;
- rodziny zewnętrzne, tranzytowe, mieszkalne i finałowe;
- większość układów scen i działań;
- finał i epilog tak, by pokazywały ludzi zamiast klasyfikacji systemowych.

Docelowa trasa ma 18 adresów liniowych, jeden z trzech wariantów 42A/B/C i
Station 43 — 20 odwiedzanych adresów w jednym przebiegu. Stacje 19–41 tracą
status obowiązkowej trasy i stają się wyłącznie materiałem do klasyfikacji
`KEEP / ADAPT / RETIRE`.

`TECHNICAL PASS` i `PRODUCT GO` stają się oddzielnymi werdyktami. PKG-0154
pozostaje prawdziwym dowodem technicznym i dawcą, lecz nie upoważnia do wydania
obecnej formy. Release i nowe `.exe` pozostają zablokowane do nowego produktowego
GO oraz osobnego polecenia właściciela.

Plan wykonawczy: `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`.

## Alternatives Considered

### IN_PLACE_REBUILD

Odrzucone. Zachowałoby 43-ekranowy balast, wspólną gramatykę lokacji i monolity,
które są źródłem problemu. Małe poprawki prezentacyjne nie naprawiają fundamentu
komunikacji.

### REMAKE_FROM_ZERO_USING_EXISTING_MATERIAL

Odrzucone jako ścieżka główna. Niepotrzebnie wyrzuciłoby sprawny shell, save,
InputMap, fizykę, kamerę, compositor, dostępność i testy. Ten wariant pozostaje
planem odwrotu dla warstwy contentu, jeśli dwa checkpointy odbudowy zakończą się
`CUT`.

## Consequences

- P8 i stary release plan przestają być aktywnym kierunkiem.
- Otwiera się P9: Product Rescue & Hybrid Rebuild.
- PKG-0155 jest pakietem planistycznym i nie zmienia runtime.
- Następny pakiet wykonuje PHASE-01 / BUNDLE-01..05 bez implementacji scen.
- Nie polerujemy starych 43 scen przed zatwierdzeniem targetu, mapy kampanii,
  rodzin lokacji i macierzy akceptacji.
- Po każdym piątym bundle'u obowiązuje checkpoint GO/PIVOT/CUT.
- Dwa sygnały radykalizacji wymuszają `REMAKE_FROM_ZERO_USING_EXISTING_MATERIAL`
  dla contentu, przy zachowaniu technologii dawcy.
