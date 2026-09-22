# PKG-0241 — plan wdrożenia i dalszego odbioru

Plan wynika z [raportu](PKG_0241_REPORT.md). „Wdrożone” oznacza zmieniony kod/asset i wskazany dowód, nie zaliczenie całej gry. Baza: `71d937329385368e718b947b43f84fed00324d57`. Wszystkie operacje na oddzielnej gałęzi `fix/art-ux-audit-0241`; żadnego force-push ani nadpisywania poprzedniej gałęzi 0240.

## Pakiet W1 — uruchomienie i odtwarzalność · WDROŻONY

1. Sprawdzić błąd importu w `narrative_repair_rules.gd`; dopisać typ bool bez zmiany treści warunku.
2. Odtworzyć źródła vendor z istniejących `.ctex`, nie projektować nowej postaci. Zanotować blob SHA, wielkość obrazu i SHA256 PNG. Nie dodawać cache do commita. Dodać wyjątek `.gitignore` dla `/assets/characters/vendor/` i PNG: nazwa postaci nie jest katalogiem zależności.
3. Dodać do `verify.ps1` parametr sterownika audio; domyślnie zachować WASAPI. Dummy ma być jawnie oznaczonym profilem CI, bez wyciszania błędów i ostrzeżeń.
4. Dodać samodzielny test PKG-0241, wywołanie w głównym weryfikatorze i uzasadnioną aktualizację census. Nie zmieniać oczekiwań narracyjnych starych testów.

**Odbiór:** czysty import; cztery poprawne tekstury; nowy test widoczny w census. Zależność: wszystkie następne pakiety wymagają działającego importu. Ryzyko: stare zapisy fabularne po PKG-0239 nie są automatycznie migrowane przez poprawkę typu.

## Pakiet W2 — dialog, pauza i tekst · WDROŻONY

1. `crt_dialogue_box.gd`: pełny tekst do layoutu, `visible_characters`, wspólna ścieżka zakończenia, kanoniczny speaker, zatrzymanie blipu. Puste kwestie i ponowne ukrycie panelu nie mogą emitować niezamierzonych zdarzeń.
2. Zatrzymać dialog, myśli, winiety i cold open w pauzie. Oddzielić Escape/pause od skip. Nie usuwać ochrony pierwszego otwarcia.
3. `inner_thought_surface.gd`: wyliczać wysokość pola i ramki z treści, zachowując skalę wybraną przez gracza. Zostawić minimalny rozmiar i możliwość ponownego zmniejszenia po długiej myśli.
4. Sprawdzić 85/100/115%, naturalny koniec, odsłonięcie, przytrzymanie klawisza, pauzę w środku zdania i pusty tekst. Nie zmniejszać czcionki w odpowiedzi na przepełnienie.

**Odbiór:** niezmienny układ słów podczas pisania, jeden line_finished, widoczna kontynuacja, nieruchome zegary w pauzie, pełna myśl przy 115%. Dowód: nowa bramka, pomiary korpusu i dwa kadry myśli. Zależność: W1.

## Pakiet W3 — menu, sterowanie i bezpieczne operacje · WDROŻONY

1. Przechwytywać przypisanie w `_input`, przed GUI. Anulowanie ma należeć do najwyższej warstwy. Nie hardkodować klawiszy akcji gry.
2. Uzupełnić next/previous dla Tab/Shift-Tab; ukrywać bazowe kontrolki przy remapie. Po zamknięciu wrócić do kontrolki otwierającej.
3. Wyśrodkować ustawienia tytułu; ukryć panel tytułu/selekcji podczas ustawień i przywrócić go przy wyjściu. Pauza kampanii nie może pojawić się na tytule.
4. Dodać mały współdzielony SafeActionDialog. Anuluj jako domyślny fokus; opis skutku PL/EN; dwa przyciski; blokada zdarzeń tła; jedno wykonanie. Nowa gra pyta przy zapisie, reset pyta zawsze; potwierdzony reset wraca do tytułu.
5. Naprawić kolejność odświeżenia komunikatu „przywrócono”. Skrócić stopkę ustawień PL/EN tak, by nie zachodziła na przycisk przy 115%; sprawdzić wszystkie sześć kombinacji języka i skali.

**Odbiór:** Input.parse_input_event odtwarza Enter/Tab; fokus nie ucieka; anulowanie nie usuwa postępu; brak podwójnego sygnału; PL/EN i skale 85/100/115 mieszczą się w kadrze. Zależność: W1/W2, bo zachowanie menu jest oceniane przy zatrzymanym świecie. Fizyczny pad i natywny profil Windows wymagają dalszego odbioru.

## Pakiet W4 — podparcie i animacja postaci · WDROŻONY

1. W scenach 42A/B/C zestawić Y rysowanej podłogi z górną krawędzią FloorMain. Skorygować tylko istniejącą podłogę do Y=306.
2. W B/C skorygować położenie Marty do jej rzeczywistego pivota; porównać stopy po ustabilizowaniu fizyki, nie tylko pozycję w edytorze.
3. W trzech klatkach Leny usunąć z alfą wyłącznie scenografię. Zachować canvas/pivot i ciepłe piksele dłoni/butów; sprawdzić kontur głowy w climb_back_0. Wpisać źródłowy i wynikowy hash do manifestu. Zachować oryginalne podeszwy i zaliczyć istniejący test PKG-0173; nie obniżać jego progu.
4. Uczynić ponowne `set_state` tego samego stanu NPC neutralnym wobec zegara animacji. Reduced motion obejmuje oddech NPC/Leny, nie wyłącza chodzenia.

**Odbiór:** 9 pomiarów finałów, 6 kontroli klatek, faza NPC i oba oddechy; ogląd pełnych kadrów i powiększeń. Nie zmieniono tempa ruchu, rozmiaru kolizji bohaterki ani układu kampanii. Zależność: W1.

## Pakiet W5 — dowody, regresja i przekazanie · WDROŻENIE Z OTWARTĄ BRAMKĄ CAŁOŚCIOWĄ

1. Zachować niezależną bazę main + udokumentowany bool i osobny katalog zapisu.
2. Wykonać 88 kadrów przed i po identycznym narzędziem, z opisem silnika i profilu renderowania. Nie nazywać tego pełnym przejściem kampanii.
3. Uruchomić nową bramkę oraz wszystkie stare testy. Wyniki: [raport](PKG_0241_REPORT.md). Wszystkie niepowodzenia opisać, nie ukrywać. Próg akceptacji poprawek: brak nowego FAIL względem porównywalnej bazy, poprawa potwierdzonych przypadków. Próg wydania: znacznie szerszy i obecnie nieosiągnięty.
4. W repozytorium przechować źródła, testy, plan, raport i manifest. Logi i PNG przekazać jako artefakty; nie dołączać plików fontów, zapisów użytkownika, `.godot` ani nowego builda.
5. Zaktualizować CURRENT_STATE, SESSION_LOG, NEXT_SESSION_PROMPT, INDEX, decyzje i ryzyka. Otworzyć PR bez automatycznego scalania. Nie zakładać, że sukces zapisu do GitHuba oznacza sukces testów.

## Odtworzenie kontroli

Wymagany Godot 4.7.2 i import projektu. Wszystkie testy/renderowanie uruchamiać na kopii projektu i osobnym profilu użytkownika; start scen może tworzyć checkpointy.

```powershell
# Maszyna Windows z urządzeniem audio — właściwy domyślny profil
pwsh -NoProfile -File tools/verify.ps1
# Serwer CI bez urządzenia audio — nie jest odsłuchem
pwsh -NoProfile -File tools/verify.ps1 -AudioDriver Dummy
# Nowa bramka, niezależnie od miejsca porażki starego zestawu
godot --headless --path . --audio-driver Dummy --script res://tests/pkg_0241_visual_ux_test.gd
# Render: normalny sterownik okna, NIE --headless
godot --path . --audio-driver Dummy --fixed-fps 60 --script res://tools/capture_pkg_0241.gd
pwsh -NoProfile -File tools/verify_docs.ps1
pwsh -NoProfile -File tools/snapshot.ps1 -Package PKG-0241
```

`GS_AUDIT_OUT` i `GS_PROBE_OUT` mogą wskazywać osobne katalogi/pliki dowodowe. Na Linux użyto osobnych `XDG_DATA_HOME` oraz Xvfb. Utworzenie snapshotu nie zastępuje commita i nie jest dowodem przejścia testów.

## Następny pakiet: bramki jeszcze otwarte

### R1 — ciągła kampania i stare testy · P0 przed wydaniem

Odtworzyć na świeżym stanie dokładny pierwszy niezaliczony przypadek smoke (zakres zgody/17, odczyty prognoz/18, wykonanie finału). Logować scenę, dostępne interakcje, indeks dialogu i decyzje przed/po. Rozdzielić błąd gry od testu zakładającego kontrakt sprzed PKG-0239. Najpierw zapisać reprodukcję, potem zmienić kod albo przygotowanie danych. Nie przyznawać zgody automatycznie i nie wycinać odmowy dla wygody testu. Wymagane przekroje: cztery kombinacje nośnika/kosztu, odmowy i przerwane rozmowy, powrót do 17/18, A/B/C oraz 43. Zaliczenie: pełna trasa i zielone testy adekwatne do aktualnych zasad.

### R2 — historyczne dowody i integracja CI · P1

Oddzielić testy bieżącego wykonania od testów żądających archiwalnych `reports/pkg_0198` itp. Najpierw ustalić, które pliki repo naprawdę przechowuje; nie generować fałszywych dawnych kadrów. Dodać jawny profil archiwalny lub dostarczyć autentyczne artefakty, zachowując znaczenie asercji. Wykonać Windows Dummy i domyślny WASAPI na maszynie z urządzeniem. Żaden profil nie może milcząco ignorować błędów silnika.

### R3 — ciągłość artystyczna · P2

Zrobić arkusz „Lena kanoniczna”: buty, mankiet, naszywka, torba, strona paska, charakter twarzy. Zestawić wszystkie 36 klatek i 14 plansz; rozstrzygnąć różnicę planu filmowego od sprzeczności kostiumu. Zmieniać tylko wskazane elementy, nie losować całych scen. Dla vendor przygotować drugą klatkę ust o tej samej sylwetce. Odbiór: zestaw przed/po, zgodny pivot/rozmiar, brak migotania masy ciała, poprawne przejścia mowy i pauzy. Nie ogłaszać R3 wdrożonym na podstawie samego odzyskania PNG.

### R4 — odbiór docelowego wyświetlania i wejścia · P1 przed wydaniem

Na docelowym Windows sprawdzić pełny ekran/okno, integer scaling, zmianę rozmiaru, wysokie DPI, trzy skale tekstu i języki. Podłączyć pad: przechwytywanie przycisku, nawigacja, anulowanie, powrót fokusu, odłączenie. Odsłuchać przerwanie blipu i przejścia ambientu. Zmierzyć czas klatki bez stałego FPS i bez programowego renderera. Kryteria muszą odróżniać 60 Hz symulacji od wydajności obrazu.

## Wycofanie i bezpieczeństwo

Wycofywać commit pakietu albo poszczególne logiczne grupy po sprawdzeniu zależności. W1 (bool i zasoby) nie zależy od pozostałych. W3 wymaga pliku SafeActionDialog i nowych kluczy lokalizacji razem. Podłogi i pozycje Marty cofać jako komplet, nie osobno. Przy powrocie do starej liczby testów skorygować census równocześnie z usunięciem nowej bramki. Nie wycofywać przez kopiowanie historycznego snapshotu na bieżący main. Zmiany nie zawierają migracji ani kasowania istniejących zapisów.
