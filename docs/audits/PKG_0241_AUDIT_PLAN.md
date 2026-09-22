# PKG-0241 — plan audytu grafiki, animacji i UX

Data: 22 września 2026. Projekt: Getting Strange. Punkt odniesienia: `71d937329385368e718b947b43f84fed00324d57` (main po scaleniu PKG-0239). Zlecenie: audyt, decyzje artystyczne, plan i implementacja. Gałąź robocza: `fix/art-ux-audit-0241`.

## Cel i granice

Sprawdzić nie tylko deklaracje dokumentacji, ale obraz oraz zachowanie uruchomionej gry. Odróżnić usterkę od świadomej stylizacji, problem sprzętu testowego od błędu gry, a naprawę od hipotezy o odbiorze. Zakres obejmuje całą aktywną trasę P9: 01–18, 42A/B/C i 43. Są to 22 sceny wykonawcze obsługujące 20 adresów kampanii. Wycofane 19–41 nie są materiałem do nowego projektu graficznego.

Nie tworzyć witryny, wersji przeglądarkowej ani nowego wydania. Nie przepisywać fabuły z PKG-0239. Zachować 640×360, fizykę 60 Hz, semantyczne akcje wejścia, istniejącą stylistykę, skalowanie tekstu 85–115% i mechanikę Zakotwiczenia. Nie dodawać zręcznościowych przeszkód. Dopuszczalne są korekty istniejącej podłogi, jeżeli nie pokrywa się z rysunkiem.

## Kolejność i warunki przejścia

| Etap | Czynność | Dowód / kryterium |
|---|---|---|
| A0 — zamrożenie bazy | Odczytać repozytorium, aktualne commity, dokumenty i wcześniejsze działania; zabezpieczyć źródła oraz wersję silnika. | Manifest Git, SHA źródeł, Godot 4.7.2, osobny katalog zapisu. Nie nadpisywać poprzedniej gałęzi 0240. |
| A1 — uruchomienie | Świeży import dokładnej bazy, odczyt logu niezależnie od kodu wyjścia. | Zanotować każdy błąd; ewentualną konieczną poprawkę rozruchową jawnie oddzielić od bazy. |
| A2 — obraz | Uruchomić każdą aktywną scenę: otwarcie, świat bez panelu, tekst 115%; menu PL/EN przy 85/100/115%. | Identyfikowalne PNG, manifest, błędy zapisu i silnika. Ogląd plansz zbiorczych i kadrów problemowych w pełnym rozmiarze. |
| A3 — animacje | Przejrzeć wszystkie 36 klatek Leny i 14 plansz winiet. Sprawdzić kontakt z podłożem, pivot, pozostałości scenografii, fazę NPC, pauzę, reduced motion. | Porównania klatek, pomiary podłogi/stóp, testy stanów i zegarów. Ruch istotny dla działania nie znika przy reduced motion. |
| A4 — UX | Zbadać dialog, odsłonięcie tekstu, pauzę, myśli, winiety, menu, remap, fokus i operacje niszczące zapis. | Rzeczywiste zdarzenia InputEvent, nie wyłącznie bezpośrednie wywołania handlerów. Anulowanie nie zmienia postępu. |
| A5 — tekst | Zmierzyć otwarcia oraz korpus literalnych kwestii w trzech skalach. Osobno sprawdzić myśli. | content height ≤ wysokość pola; brak skakania wierszy w trakcie pisania; czytelny sygnał kontynuacji. |
| A6 — selekcja zmian | Każdemu potwierdzonemu problemowi nadać ID, priorytet, źródło, poprawkę i test. | P0 blokuje start/bezpieczeństwo, P1 zakłóca kontakt z grą, P2 to dalsza poprawa jakości. Nie rozwiązywać hipotez przypadkową zmianą stylu. |
| A7 — wdrożenie | Naprawić potwierdzone usterki, zachowując pochodzenie assetów. | Mała różnica w źródłach; żaden plik fontu, cache `.godot` ani eksport nie trafia do pakietu zmian. |
| A8 — regresja | Uruchomić nowe testy i pełną listę dotychczasowych testów w porównywalnych środowiskach; wykonać nowe kadry. | Wynik zawiera także FAIL, timeout i brak danych. Nie usuwać asercji, by uzyskać zielony status. |
| A9 — przekazanie | Zapisać raport, plan wdrożenia, pochodzenie grafik i handoff; opublikować osobną gałąź/PR. | Aktualny stan i ograniczenia widoczne w repozytorium. Brak automatycznego PRODUCT GO lub wydania. |

## Macierz dowodu

Obraz: kompozycja, czytelność sylwetki, hierarchia światła/akcentów, geometria, nakładanie UI, rodziny miejsc i rozróżnienie rekwizytu od ozdoby. Animacja: chód i przejścia jako istniejący kontrakt, faza NPC, przerwanie dialogu, zatrzymanie czasu, kontury klatek i ograniczenie ruchu. UX: pierwsze wejście, nawigacja, interakcja, czytanie, pauza, ustawienia, sterowanie, powrót i bezpieczny zapis.

Testy syntetyczne nie dowodzą emocji, satysfakcji, łatwości zrozumienia fabuły ani pełnej grywalności całej kampanii. Oddzielne uruchomienie 22 scen nie jest przejściem od 01 do wszystkich zakończeń. Render Linux/Mesa nie zastępuje inspekcji natywnego obrazu Windows, a Dummy nie weryfikuje odsłuchu. Te granice obowiązują również wtedy, gdy wszystkie nowe testy przechodzą.

Wynik wykonania: [raport](PKG_0241_REPORT.md). Kolejność zmian i kryteria odbioru: [plan wdrożenia](PKG_0241_IMPLEMENTATION_PLAN.md).
