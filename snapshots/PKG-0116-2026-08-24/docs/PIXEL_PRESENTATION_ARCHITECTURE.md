# Rówień Pixel-Stage — architektura obrazu i ostrego tekstu

Status: **KANON TECHNICZNO-WIZUALNY USTANOWIONY W PKG-0116; WDROŻENIE OD PKG-0117**

## 1. Cel

Świat ma wyglądać jak świadomie skomponowany 2D pixel art, ale dialogi, myśli,
UI, napisy, etykiety i każdy tekst muszą pozostać ostre. Nie nakładamy jednego
filtra na gotową klatkę razem z interfejsem.

## 2. Warstwy kompozycji

Kolejność renderowania jest kontraktem:

1. `WorldLayer` — architektura, rekwizyty, Lena, NPC, światło, cienie i VFX;
2. `WorldPixelCompositor` — nearest-neighbor, domyślna siatka 2x2 logical px,
   czyli charakter obrazu odpowiadający 320x180 przy wyjściu 640x360;
3. `CrispDiegeticTextLayer` — tablice, monitory, dokumenty i napisy należące
   do świata, lecz czytane jako tekst;
4. `CrispGameplayUILayer` — prompt interakcji, myśli, dialog, cele i feedback;
5. `CrispSystemUILayer` — pauza, ustawienia, shell, napisy i accessibility.

Każda warstwa tekstowa renderuje w natywnym 640x360 i dziedziczy skalę tekstu.

## 3. Implementacja docelowa

Preferowany wariant Godot 4.7:

- świat trafia do osobnego `SubViewport` lub równoważnego bufora 640x360;
- kompozytor kwantyzuje próbki do stałej siatki 2x2 i skaluje nearest;
- wszystkie warstwy crisp są rodzeństwem tekstury świata, nie dziećmi
  spikselizowanego viewportu;
- kamera i fizyka nadal używają współrzędnych 640x360;
- filtr nie zmienia kolizji, InputMap, logiki stacji ani pozycji kamery;
- ustawienie debug pozwala przełączyć 1x/2x/3x do testu, ale domyślna produkcja
  używa 2x; opcja gracza wymaga osobnej decyzji dostępnościowej.

Wariant pełnoekranowego `ColorRect` czytającego `SCREEN_TEXTURE` jest
dopuszczalny tylko wtedy, gdy wszystkie crisp warstwy powstają po nim. Nie
może przypadkiem objąć tekstu narysowanego w `_draw()` stacji.

## 4. Dług migracyjny tekstu

Audyt PKG-0116 znalazł 33 skrypty poziomów z `draw_string()` lub
`draw_multiline_string()`. Taki tekst znajduje się w warstwie świata i zostałby
rozpikselizowany. Przed włączeniem kompozytora dla danego wycinka:

- dialogi przechodzą do wspólnego `CRTDialogueBox`;
- myśli przechodzą do `InnerThoughtSurface`;
- podpisy pomieszczeń i terminali przechodzą do `CrispDiegeticTextLayer`;
- prompt nie zawiera stałego `[E]`, tylko semantyczną akcję/binding;
- tekst nie jest przechowywany w tablicy skryptu stacji; używa kluczy treści;
- test inwentaryzacyjny odrzuca nowe `draw_string()` w warstwie świata.

## 5. Zasady pixel artu

- siatka jest stabilna względem kamery; piksele nie pełzają przy postoju;
- obiekty ważne mają minimum 2x2 finalnych pikseli na kluczowy detal;
- kontur świata po pixelizacji ma zwykle jeden finalny piksel;
- brak automatycznego ditheringu, CRT scanlines i szumu VHS jako wypełniacza;
- paleta Vector-Stage pozostaje ograniczona; pixelizacja zmienia raster, nie
  nadaje przypadkowych kolorów;
- subpixelowy ruch może istnieć w fizyce, ale prezentacja jest kwantyzowana w
  sposób stabilny i nie powoduje drżenia stóp Leny;
- efekty anomalii nadal znaczą konkretny stan i nie stają się dekoracyjną
  korupcją całego ekranu.

## 6. Tekst i dostępność

- tekst pozostaje w natywnym rastrze 640x360;
- font i jego licencja muszą mieć komplet PL/EN;
- skala 85–115% z R1 pozostaje minimalnym zakresem i nie może powodować
  overflow w 640x360;
- tekst ma kontrastową płaszczyznę, nie opiera się na świecie po filtrze;
- światowy bloom, mgła, światło i pixel shader nie modyfikują glifów;
- screenshot gate porównuje krawędzie świata i tekstu: świat ma powtarzalne
  bloki 2x2, pionowe/poziome krawędzie glifów zachowują natywny raster;
- tryb ograniczenia migania obejmuje światowe anomalie, nie usuwa informacji.

## 7. Kryteria akceptacji

- świat w capture 640x360 ma stabilną siatkę 2x2;
- dialog, myśl, prompt, tablica i menu zachowują natywną ostrość;
- obrót/skok Leny nie powoduje migotania siatki ani rozmycia;
- nie istnieje źródło tekstu w spikselizowanej warstwie migrowanego wycinka;
- skale 85%, 100% i 115% mieszczą się w safe area;
- capture'y obejmują świat bez UI, świat z dialogiem, myśl, tablicę, pauzę i
  shell;
- test techniczny nie jest nazywany dowodem subiektywnej czytelności.
