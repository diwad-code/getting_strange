# Prompt dla następnej sesji: PKG-0091 (Mega-Pakiet Offline PWA, Runtime E2E i Dostępności Portalu Web)

## CEL SESJI

Zgodnie z decyzją **D-090 (Priorytet Ukończenia Portalu Web)** strona ma być kompletna również bez sieci i pod kontrolą testów behawioralnych:

1. **Pełna Dostępność Offline PWA (`web/service-worker.js`)**:
   - Rozszerzenie `ASSETS_TO_CACHE` o komplet 92 kadrów `assets/reports/*.png` (galeria 43 przestrzeni i kadry laboratoryjne), tak aby po pierwszej wizycie cały portal działał offline;
   - Strategia cache-first dla obrazów i network-falling-back dla reszty; test kontraktowy: każdy plik z `assets/reports` występuje w cache list.
2. **Faza Behawioralna Runtime Smoke (`tools/web_runtime_smoke.js`)**:
   - Rozbudowa shima DOM o rejestr elementów po id, tak aby można było wykonać kluczowe ścieżki: `openDossierModal('doc1')` + `closeDossierModal()`, `executeRetroTerminalCmd('help')` / `('status')` / `('dossier 5')`, `resetProgress()` na silniku komór, odczyt parametrów projektanta sygnałów;
   - Asercje: brak wyjątków, modal otrzymuje klasę `active`, historia terminala rośnie, postęp resetuje się do 01/20.
3. **Audyt Dostępności i Responsywności (`web/index.html`, `web/css/style.css`)**:
   - `:focus-visible` dla wszystkich przycisków i suwaków, `aria-label` dla kontrolek dotykowych i ikonowych, kontrast tekstu mutowanego, media queries dla < 768 px (siatki, toolbar, modale);
   - Test kontraktowy: brak kontrolek bez nazwy dostępności w audycie statycznym.
4. **Synchronizacja Telemetrii Portalu**: stopka, komenda `status`, manifesty pobierania → stan PKG-0091.
5. **Automatyczne Testy i Weryfikacja**: `pwsh -NoProfile -File .\tools\verify.ps1`, aktualizacja dokumentacji i zamrożenie snapshotu PKG-0091.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, Node.js v26 (runtime smoke), brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-090, ADR-004).
- Baseline: Portal Web w 100% funkcjonalny (PKG-0089) z pełną pętlą progresji 20 komór i zapisem stanu (PKG-0090); audyty martwych kontrolek i eksportów raportują 0; runtime smoke PASS (fazy 1-4).
- Weryfikacja: `tools/verify.ps1` przechodzi w 100% z wynikiem PASS, w tym WEB RUNTIME SMOKE.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Service worker cache'uje komplet assetów (92 kadry + bundle); kontrakt w `verify_web.ps1`.
3. Runtime smoke zawiera fazę behawioralną z co najmniej 6 asercjami kluczowych ścieżek — wszystkie PASS.
4. Kontrolki interaktywne mają `:focus-visible` i nazwy dostępności; media queries < 768 px dla głównych siatek.
5. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
6. Zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0091`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0091 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0091`.
