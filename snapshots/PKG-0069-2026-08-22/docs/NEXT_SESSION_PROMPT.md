# Prompt dla następnej sesji: PKG-0070

## CEL SESJI

Dalsze rozszerzenia multimedialne portalu webowego, interaktywne narzędzia eksploracji świata i akustyki Równi 1978 oraz dalsza automatyzacja pipeline'u produkcyjnego **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0069: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7.
- Oficjalny portal webowy w `web/` posiada:
  - symulator fizyki Canvas 2D (8 komór: 01..08, w tym Reaktor Centralny -85m, Sala Modeli i Podstruktura -40m, profile A/B/C, dotyk, fullscreen, real-time HUD);
  - galerię 43 kadrów z wyszukiwarką na żywo, interaktywnym planem sektorów Równi, schematem Linii 4 oraz Radarem Geologicznym Głębokich Warstw Równi (+15m do -85m);
  - aparaturę audio z master volume, mute, analizatorem widma 512 FFT, generatorami tła, syntezatorem polifonicznym `PolyphonicRetroSynth` (4 motywy, 16 diod LED, tempo, filtr, arp), `CustomSignalDesigner` z eksportem 16-bit WAV PCM, 32-padowym dotykowym soundboardem proceduralnym oraz Magnetofonem Szpulowym Tonik-78 (`ReelToReelTapeDeck`) z 4 taśmami, emulacją wow & flutter, prędkościami 9.5/19/38 cm/s, nasyceniem saturatora i balistycznymi wskaźnikami VU;
  - czytnik 20 scen dialogowych z autoodtwarzaniem, regulacją prędkości, syntezą wokalną w czasie rzeczywistym oraz Matrycą Relacji i Charakterystyką 6 Postaci Kanonu;
  - symulator wyborów z dynamicznymi paskami wag wektorów finałowych A/B/C;
  - odtajnione akta archiwalne IKP/UCP (8 dokumentów: doc1..doc8 z filtrami kategorii), oficjalny Generator Certyfikatów Weryfikacji IKP (Canvas 2D z eksportem PNG i podpisem SHA-256) oraz Terminal Deszyfrujący IKP z matrycowym dekodowaniem kryptoanalitycznym CRT;
  - automatyczną walidację statyczną `tools/verify_web.ps1` w bramce `tools/verify.ps1`;
  - dystrybucję z generatorem paczek `tools/package_release.ps1` (`dist/getting_strange_web_showcase_v1.0.zip` wraz z SHA-256 i manifestem).
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0069-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować zadania przewidziane dla PKG-0070.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0070`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0070 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0070`.

