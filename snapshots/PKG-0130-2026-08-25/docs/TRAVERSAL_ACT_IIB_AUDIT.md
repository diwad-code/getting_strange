# Audyt przeszkód Aktu IIb — Station 16..20 (PKG-0101)

Data: 2026-08-24  
Zakres: wyłącznie gra Godot 4.7, pionowy plaster Station 16..20.  
Odpowiedzialność: Lead Programmer i Art Director (D-025, D-085, D-096,
D-099, D-101, ADR-004).

## Decyzja zakresu

Nie każda przestrzeń potrzebuje przeszkody. Station 16 jest rozmową przy stole,
a Station 18 jest wywiadem i pomiarem; obie sceny zachowują rytm obserwacji bez
dopisanej próby fizycznej. Przeszkody wdrożono tylko tam, gdzie urządzenie lub
rekwizyt już istnieje w kanonie sceny.

| Stacja | Rodzina R | Rzecz ze świata | Mechanika | Koszt korekty |
|---|---|---|---|---|
| 16 | — | stół Marty, filiżanka, teczka, obrączka | brak sztucznej przeszkody; interakcje rekwizytów pozostają obserwacyjne | brak |
| 17 | R5 — cykl infrastruktury | `Geometry/PneumaticDossierCapsule` | `AnimatableBody2D` wykonuje cykl zamknięcie → dostarczenie → otwarcie; Lena przechodzi, gdy kapsuła odsuwa się na stanowisko | reset do wejścia, wyblaknięcie cyfry na bilecie, `station_17_pneumatic_capsule_corrected` |
| 18 | — | biurko, galwanometr, przewód naprężenia | brak sztucznej przeszkody; pomiar zostaje krótką sceną stanu | brak |
| 19 | R1 — niezgodność wersji | `Geometry/Line4ModelTable` | `AnchorableObject`; dwie równoprawne wersje zmieniają rozmiar na tym samym miejscu, a zakotwiczenie opiera się korekcie | reset do wejścia, wyblaknięcie krawędzi rejestru, `station_19_model_table_corrected` |
| 20 | R1 — niezgodność wersji | `Geometry/SzymonWellDrawing` | `AnchorableObject`; rysunek ma dwie wiarygodne wersje papieru na tym samym miejscu, a wybór zakotwicza konkretny ślad | reset do wejścia, wymazanie/wyblaknięcie podpisu Igi, `station_20_drawing_corrected` |

## Przeszkoda — Station 17

### PRZESZKODA — dlaczego to tu jest

Kapsuła pneumatyczna wykonuje własny cykl dostarczania teczki między stacją
odbiorczą a gabinetem UCP.

### PRZESZKODA — czego wymaga od Leny

Odczytania syku i przejścia przez próg, gdy kapsuła odsuwa się na swoje
stanowisko robocze.

### PRZESZKODA — koszt porażki

Korekta odsyła Lenę do automatu, a numer sprawy na bilecie traci jedną cyfrę,
bo urząd uzgadnia zapis pod jej nieobecność.

Kapsuła porusza się wyłącznie dlatego, że wykonuje pracę pneumatycznego
urządzenia. Nie jest platformą, celem skoku ani nowym czasownikiem ruchu.
`PNEUMATIC_CYCLE_DURATION` wynosi 4 sekundy; faza otwarcia jest jawna w stanie
sceny, a korekta jest wywoływana przez przejście w zamkniętym momencie lub
akcję `trigger_correction`.

## Przeszkoda — Station 19

### PRZESZKODA — dlaczego to tu jest

Stół modeli przechowuje dwie równoprawne wersje zdarzenia Linii 4, których
rozmiar zmienia się przy uzgadnianiu urzędu.

### PRZESZKODA — czego wymaga od Leny

Utrzymania jednego modelu przy sobie przed przejściem dalej albo świadomego
oddania miejsca drugiej wersji.

### PRZESZKODA — koszt porażki

Korekta odsyła Lenę do wejścia, a krawędź rejestru jedenastu osób traci ślad
używania, ponieważ sala wybiera wygodniejszy układ.

`state_a_position` i `state_b_position` są identyczne; różni się wyłącznie
rozmiar dwóch wersji (`190×54` i `118×54`). Trzymany obiekt emituje opór i
pozostaje w wersji A. Nietrzymany obiekt przechodzi przez wersję B, po czym
checkpoint przywraca wersję A i zapisuje koszt.

## Przeszkoda — Station 20

### PRZESZKODA — dlaczego to tu jest

Rysunek studni istnieje w dwóch wersjach papieru, bo korekta zachowała skażenie
wody, ale wymazała osobę, która je wykryła.

### PRZESZKODA — czego wymaga od Leny

Zakotwiczenia konkretnego śladu przed oddaniem świadectwa albo świadomego
pozostawienia go procedurze UCP.

### PRZESZKODA — koszt porażki

Korekta odsyła Lenę do wejścia, a podpis Igi znika z papieru na stałe, choć
publiczny raport o wodzie pozostaje.

`state_a_position` i `state_b_position` są identyczne; różni się zakres
rysunku (`52×32` i `30×22`). Wybór `ANCHOR_DRAWING` utrzymuje konkretny ślad
przeciw korekcie. Uległość przechodzi przez wersję B, przywraca checkpoint i
utrwala wyblaknięcie detalu.

## Dowód techniczny i ograniczenia

- `tests/pkg_0101_smoke_test.gd` ładuje wszystkie sceny, sprawdza profile
  Vector-Stage, realne floor/shell colliders, `AirlockZone`, promienie
  rekwizytów, pierwszy krok `draw_play_plane()`, trzy pytania, działanie
  przeszkód oraz łańcuch 16..25 przy niezmienionym limicie 25.
- `tools/capture_pkg_0101.gd` wygenerował na normalnym Windows/OpenGL kadry
  `reports/pkg_0101/station_16.png`..`station_20.png`; każdy kadr został
  obejrzany. Droga ma najwyższy kontrast, akcenty stanu są punktowe, a
  przeszkody są rzeczami świata.
- `tools/verify.ps1` pozostaje jedynym pełnym kontraktem publikacji lokalnej;
  gate PKG-0101 jest wpięty bez usuwania wcześniejszych bramek.

Testy i capture dowodzą kontraktów technicznych oraz obecności wizualnej. Nie
dowodzą funu, emocji, zrozumienia ani jakości odbioru przez zewnętrzną osobę
(D-012, ADR-003). ObjectDB leak warnings pozostają szumem technicznym silnika
i nie zmieniają kodu wyjścia bramek.

## Hipotezy do późniejszej walidacji

- H-0101-A: cykl kapsuły w Station 17 może być czytelniejszym rytmem wejścia
  niż kolejny statyczny próg administracyjny.
- H-0101-B: identyczne pozycje i różne rozmiary modeli/rysunku zachowują
  niezgodność jako spór o zapis, nie jako platforming.
- H-0101-C: pozostawienie Station 16 i 18 bez przeszkody utrzymuje oddech
  obserwacyjny Aktu IIb, zamiast wymuszać mechaniczną aktywność w każdej sali.
