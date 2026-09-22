# Prompt dla następnej sesji: PKG-0071

## CEL SESJI

Dalsze rozszerzenia audiowizualne, interaktywne moduły symulacji falowej, zaawansowane narzędzia analizy czasoprzestrzennej miasta Rówień oraz dalsza automatyzacja pipeline'u produkcyjnego **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0070: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7.
- Oficjalny portal webowy w `web/` posiada:
  - symulator fizyki Canvas 2D (10 komór: 01..10, w tym Rozjazd Linii 4 i Sfera Zero-Point, profile A/B/C, dotyk, fullscreen, real-time HUD);
  - galerię 43 kadrów z wyszukiwarką na żywo, interaktywnym planem sektorów Równi, schematem Linii 4 oraz Radarem Geologicznym Głębokich Warstw Równi (+15m do -85m);
  - aparaturę audio z master volume, mute, analizatorem widma 512 FFT, generatorami tła, syntezatorem polifonicznym `PolyphonicRetroSynth`, `CustomSignalDesigner` z eksportem 16-bit WAV PCM, 32-padowym soundboardem, Magnetofonem Szpulowym Tonik-78 (`ReelToReelTapeDeck`), 4-śladowym Mikserem Kasetowym Unitra Studio M-531S (`UnitraMultitrackMixer`) z miksem WAV Master oraz Kineskopowym Analizatorem Wektorowym Lissajous (`LissajousVectorScope`);
  - czytnik 20 scen dialogowych z autoodtwarzaniem, regulacją prędkości, syntezą wokalną w czasie rzeczywistym oraz Matrycą Relacji i Charakterystyką 6 Postaci Kanonu;
  - symulator wyborów z dynamicznymi paskami wag wektorów finałowych A/B/C;
  - odtajnione akta archiwalne IKP/UCP (10 dokumentów: doc1..doc10 z filtrami kategorii), oficjalny Generator Certyfikatów Weryfikacji IKP (Canvas 2D z eksportem PNG i podpisem SHA-256), Terminal Deszyfrujący IKP oraz Wiersz Poleceń CLI IKP/UCP (`IKPRetroTerminal` z 11 komendami);
  - automatyczną walidację statyczną `tools/verify_web.ps1` w bramce `tools/verify.ps1`;
  - dystrybucję z generatorem paczek `tools/package_release.ps1` (`dist/getting_strange_web_showcase_v1.0.zip` wraz z SHA-256 i manifestem).
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0070-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować zadania przewidziane dla PKG-0071.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0071`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0071 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0071`.


