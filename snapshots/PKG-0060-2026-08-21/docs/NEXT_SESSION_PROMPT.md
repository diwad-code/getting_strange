# Prompt dla następnej sesji: PKG-0061

## CEL SESJI

Wdrożenie nowoczesnego, interaktywnego portalu WWW (`web/index.html`, style CSS, skrypty JS) prezentującego grę **Getting Strange**, zintegrowaną galerię kadrów wszystkich 43 przestrzeni z silnika Godot, interaktywny syntezator audio z generowaniem dźwięków proceduralnych w Web Audio API, interaktywną oś czasu kontinuum fabularnego (5 Aktów / 43 Przestrzenie), odtwarzacz scenariusza dialogowego (D-01..D-15) oraz sekcję dystrybucji/instalacji.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0060: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w pełni zaimplementowane w silniku i pomyślnie przechodzą testy automatyczne `tools/verify.ps1`.
- Wszystkie kadry wizualne są wygenerowane w katalogu `reports/*.png`.
- Proceduralne audio jest zaimplementowane w `scripts/audio/procedural_audio.gd`.

## KRYTERIA AKCEPTACJI

1. Utworzyć katalog `web/` z pełną strukturą assetów, skryptów i stylów.
2. Zaimplementować `web/index.html` z responsywnym interfejsem w kanonicznej palecie modernistycznej Równi (`#05080c`, `#0a1015`, `#16242e`, `#5da398`, `#d39a62`, `#c65d58`).
3. Zaimplementować w `web/js/audio-synth.js` syntezator Web Audio API odtwarzający proceduralne efekty dźwiękowe z gry (tony kotwiczenia, impulsy fali korekty, radio Linii 4, uderzenia w szynę tramwajową, dron epilogu).
4. Zaimplementować w `web/js/gallery.js` przeglądarkę kadrów wysokiej rozdzielczości ze wszystkich 43 przestrzeni fabularnych (z `reports/*.png`).
5. Zaimplementować w `web/js/story-timeline.js` interaktywną mapę Aktów I..IV z drzewem decyzji, poszlakami ciągłości i skryptem dialogowym.
6. Przetestować działanie strony w przeglądarce i zweryfikować poprawność działania wszystkich modułów.
7. Uruchomić i zaliczyć `pwsh -NoProfile -File .\tools\verify.ps1`.
8. Zaktualizować dokumentację (`DECISION_LOG.md`, `SESSION_LOG.md`, `ROADMAP.md`, `CURRENT_STATE.md`) i zamrozić snapshot `PKG-0061`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0061 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md`, `docs/ROADMAP.md`) oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0061`.
