# Prompt dla następnej sesji: PKG-0090 (Mega-Pakiet Pełnej Pętli Gry na Portalu Web)

## CEL SESJI

Zgodnie z decyzją **D-090 (Priorytet Ukończenia Portalu Web)**, 100% prac kierujemy na dokończenie strony jako grywalnej, kompletnej całości — każda funkcja zadeklarowana przez stronę musi działać:

1. **Pętla Progresji Komór 01..20 (`web/js/game-engine.js`, `web/index.html`)**:
   - Ekran startowy symulatora, sekwencyjne odblokowywanie komór 01→20, ekran ukończenia z podsumowaniem;
   - Trwały stan postępu w `localStorage` (odblokowane komory, zebrane poszlaki, ostatnia komora) z przyciskiem resetu;
   - Telemetria postępu w nagłówku symulatora (komora X/20, czas, liczba kotwiczeń).
2. **Audyt Kompletności Interakcji (regresja D-090)**:
   - Uruchomić `tools/audit_web_dead_controls.ps1` i `tools/audit_web_exports.ps1` — oba muszą raportować 0;
   - Przejść wszystkie 6 zakładek (tab-overview..tab-distribution) i domknąć każdą obietnicę UI (przycisk, suwak, lista) działającym kodem;
   - Zweryfikować zachowanie offline PWA (service worker, cache assetów galerii).
3. **Test Przeglądarkowy Kluczowych Ścieżek**:
   - Czytnik 100 akt (modal + filtry + komenda `dossier N` w CLI), Projektant Sygnałów (odsłuch + eksport WAV), Terminal IKP-78 (polecenia + szybkie przyciski), Galeria 43 przestrzeni (modal + wyszukiwarka), Magnetofon Tonik-78 (taśmy 1..4, prędkości, saturacja);
   - Rozszerzyć `tools/web_runtime_smoke.js` o asercje nowych modułów pętli progresji.
4. **Synchronizacja Telemetrii Portalu**:
   - Manifesty pobierania (`downloadReleasePackage`), stopka i komenda `status` w CLI mają raportować stan PKG-0090 i faktyczne liczniki modułów.
5. **Automatyczne Testy i Weryfikacja**:
   - `pwsh -NoProfile -File .\tools\verify.ps1`, aktualizacja dokumentacji i zamrożenie snapshotu PKG-0090.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, Node.js v26 (runtime smoke), brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-090, ADR-004).
- Baseline: Portal Web w 100% funkcjonalny po PKG-0089 (0 martwych kontrolek, 0 brakujących eksportów, runtime smoke PASS, 100 akt dostępnych w czytniku); wszystkie 43 przestrzenie fabularne istnieją w Godot 4.7.
- Weryfikacja: `tools/verify.ps1` przechodzi w 100% z wynikiem PASS, w tym WEB RUNTIME SMOKE.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Wdrożyć pętlę progresji komór 01..20 z zapisem stanu i ekranami start/koniec.
3. Domknąć wszystkie interakcje strony; audyty martwych kontrolek i eksportów raportują 0.
4. Rozszerzyć runtime smoke test o moduły pętli progresji.
5. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`, `docs/DECISION_LOG.md`).
6. Zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0090`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0090 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0090`.
