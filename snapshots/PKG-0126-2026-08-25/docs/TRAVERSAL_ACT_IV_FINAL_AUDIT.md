# Audyt traversal Aktu IV — finały 42A–42C i epilog 43

Status: **AUDYT ZAMKNIĘTY — PKG-0107**  
Data: 2026-08-24  
Zakres: `station_42a`, `station_42b`, `station_42c`, `station_43` w Godot 4.7.

## 1. Dowód wejściowy

Przed edycją wykonano:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: **PASS**, exit code 0. Przeszły kontrakt dokumentacji, import Godot,
`tests/smoke_test.gd`, `tests/traversal_lint_test.gd` i bramki PKG-0095,
0096, 0097, 0099, 0100, 0101, 0102, 0103, 0104, 0105 oraz 0106. Godot wypisał
znane ostrzeżenia `ObjectDB/RID leak` przy zamknięciu kilku bramek; nie było
błędu parsera ani błędu runtime wpływającego na kod wyjścia.

## 2. Inwentaryzacja wspólnego shellu

Każda z czterech scen ma ten sam, istniejący shell:

| Element | Typ i pozycja | Kształt | Status |
|---|---|---|---|
| `Geometry/FloorMain` | `StaticBody2D`, `(320, 316)` | `RectangleShape2D (640, 80)` | istniejąca podłoga |
| `Geometry/Ceiling` | `StaticBody2D`, `(320, 24)` | `RectangleShape2D (640, 48)` | istniejący sufit |
| `Geometry/WallLeft` | `StaticBody2D`, `(-10, 180)` | `RectangleShape2D (20, 360)` | istniejąca ściana |
| `Geometry/WallRight` | `StaticBody2D`, `(650, 180)` | `RectangleShape2D (20, 360)` | istniejąca ściana |
| `AirlockZone` | `Area2D`, `(610, 248)` | `RectangleShape2D (50, 70)` | istniejące wyjście sceny |

Droga biegnie po dolnej płaszczyźnie od startu Leny `(65, 248)` do istniejącej
strefy wyjścia przy prawej ścianie. W pakiecie nie wolno jej przesuwać ani
zmieniać jej kształtu.

## 3. Scena 42A — Powrót / Własny pokój

### Funkcja świata i droga

Komora składa się do układu pierwszego pomiaru, a Lena żegna Martę i wraca do
własnej gałęzi. Rekwizyty to `Props/ReturnCups` (`return_cups`, promień 48 px)
i `Props/Station42AExit` (`station_42a_exit`, promień 60 px). Istniejąca logika
prowadzi od inspekcji dwóch kubków przez dziewięć kwestii D-15A do
`is_exit_unlocked`, a wejście do `AirlockZone` emituje `level_completed`.

### Przeszkoda

Nie dodano przeszkody. W scenie nie istnieje `AnimatableBody2D`,
`AnchorableObject` ani dodatkowy `StaticBody2D`; jedyne ciała fizyczne to cztery
elementy shellu wymienione wyżej.

### Trzy pytania kanonu

1. **Dlaczego to tu jest?** Komora ma odtworzyć procedurę pierwszego pomiaru i
   umożliwić pożegnanie przed zmianą adresu ciągłości.
2. **Czego wymaga od Leny?** Obejrzenia dwóch kubków, przyjęcia rozdzielenia
   własnej pamięci od żywego Jakuba oraz przejścia do otwartej śluzy.
3. **Co dzieje się, gdy się nie uda i dlaczego to boli fabularnie?** Nie ma
   wykonawczej porażki; bez domknięcia dialogu wyjście pozostaje zamknięte,
   więc koszt decyzji pozostaje nazwany, a nie zamieniony w test zręczności.

## 4. Scena 42B — Uzgodnienie / Miejsce po niej

### Funkcja świata i droga

Lena przyjmuje lokalny wzorzec, ale Marta sprawdza decyzję podjętą już po
przybyciu. Rekwizyty to `Props/MartaDoorstep` (`marta_doorstep`, promień 48 px)
i `Props/Station42BExit` (`station_42b_exit`, promień 60 px). Istniejąca logika
prowadzi przez osiem kwestii D-15B do otwarcia wyjścia; `AirlockZone` zachowuje
dotychczasowy sygnał ukończenia.

### Przeszkoda

Nie dodano przeszkody. Nie ma `AnimatableBody2D`, `AnchorableObject` ani
dodatkowego `StaticBody2D`. Próg jest rekwizytem narracyjnym `Area2D`, nie
colliderem ani torem skoku.

### Trzy pytania kanonu

1. **Dlaczego to tu jest?** Próg mieszkania jest miejscem, w którym Marta
   decyduje, czy odpowiedź Leny ma własny, późniejszy sens.
2. **Czego wymaga od Leny?** Zmierzenia się z pytaniem Marty i przejścia przez
   próg dopiero po wypowiedzeniu odpowiedzialności własnymi słowami.
3. **Co dzieje się, gdy się nie uda i dlaczego to boli fabularnie?** Nie ma
   porażki fizycznej; bez odpowiedzi drzwi nie otwierają następnego kroku,
   ponieważ relacja nie może zostać przyznana przez samą biografię lokalną.

## 5. Scena 42C — Świadectwo / Dwie prawdy

### Funkcja świata i droga

Poranny tramwaj zatrzymuje się przed dwoma nakładającymi się torami, a wspólna
obserwacja pozwala wybrać jeden kierunek bez wymazania drugiego. Rekwizyty to
`Props/TramDualTracks` (`tram_dual_tracks`, promień 48 px) i
`Props/Station42CExit` (`station_42c_exit`, promień 60 px). Istniejąca logika
prowadzi przez trzynaście kwestii D-15C do otwarcia wyjścia i sygnału
`level_completed` w `AirlockZone`.

### Przeszkoda

Nie dodano przeszkody. Dwa tory są obserwowanym motywem fabularnym w `Area2D`,
nie geometrią blokującą; scena ma zero `AnimatableBody2D`, `AnchorableObject`
i dodatkowych `StaticBody2D`.

### Trzy pytania kanonu

1. **Dlaczego to tu jest?** Dwa tory pozostają jawnie obecne, aby publiczna
   sieć mogła utrzymać sprzeczność i ustalić kierunek przejazdu.
2. **Czego wymaga od Leny?** Utrzymania obu prawd w obserwacji, uznania kosztu
   rozproszenia Śladu i przejścia bez wybierania jednej osoby jako dowodu.
3. **Co dzieje się, gdy się nie uda i dlaczego to boli fabularnie?** Nie ma
   porażki wykonawczej; brak wspólnej obserwacji nie kasuje drugiego toru, lecz
   pozostawia scenę niedomkniętą, bo jawność sprzeczności jest kosztem finału.

## 6. Scena 43 — Napisy i epilog systemowy

### Funkcja świata i droga

Napisy są zapisane na zwyczajnych elementach miasta, a krótki komunikat
administracyjny zależy od wybranego finału. Rekwizyty to
`Props/AdminNoticeBoard` (`admin_notice_board`, promień 48 px),
`Props/CreditsRoll` (`credits_roll`, promień 48 px) i
`Props/FinalBlackout` (`final_blackout`, promień 60 px). Istniejąca logika
prowadzi przez pięć komunikatów, a wejście do `AirlockZone` emituje
`level_completed` po odblokowaniu wygaszenia.

### Przeszkoda

Nie dodano przeszkody. Tablica, napisy i wygaszenie są rekwizytami
`Area2D`; scena ma zero `AnimatableBody2D`, `AnchorableObject` i dodatkowych
`StaticBody2D`. Nie powstaje mechaniczny tor po napisach.

### Trzy pytania kanonu

1. **Dlaczego to tu jest?** Miasto zapisuje konsekwencje finału na własnych
   rozkładach, kartach i tablicach zamiast dopowiadać jedną prawdziwą wersję.
2. **Czego wymaga od Leny?** Odczytania zwyczajnych komunikatów, rozpoznania
   ich różnicy po finale i odejścia po świadomym wygaszeniu.
3. **Co dzieje się, gdy się nie uda i dlaczego to boli fabularnie?** Nie ma
   porażki fizycznej; bez odczytania i wygaszenia epilog nie zostaje zamknięty,
   więc odpowiedzialność pozostaje otwartym komunikatem, nie karą zręcznościową.

## 7. Decyzja audytu

Łączny budżet nowych przeszkód w PKG-0107 wynosi **0**. Jest to świadoma cisza
zgodna z D-099: finały rozstrzygają odpowiedzialność przez rekwizyty, dialog,
obserwację i istniejącą drogę do śluzy. Nie ma uzasadnienia dla dokładania
geometrii tylko po to, by wypełnić kadry, a limit dwóch przeszkód z handoffu
nie jest obowiązkiem wykorzystania.

Wszystkie zmiany tego pakietu dotyczą wyłącznie warstwy prezentacji
Vector-Stage i jej dowodów. Shell collidery, `AirlockZone`, zasięgi
rekwizytów, sygnały, flagi finałów, koszty, `GameStateManager`, InputMap,
fizyka 60 Hz, Station 41, limit kampanii 25 i schemat zapisu 1 pozostają poza
zakresem zmian.
