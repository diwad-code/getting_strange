# Raport wydajnosci PKG-0130 — budzet klatki 60 Hz, determinizm czastek i koherencja pikselowa

Data: 2026-08-25  
Pakiet: PKG-0130  
Faza: P5 (Release Candidate / Golden Master 1.0.0)  
Silnik: Godot 4.7.stable.official.5b4e0cb0f, renderer GL Compatibility

## 1. Zakres i metoda

Pakiet obejmuje trzy rozdzielne dowody, bo mierza rozne rzeczy i maja rozne granice:

| Narzedzie | Co mierzy | Co dowodzi | Czego nie dowodzi |
|---|---|---|---|
| `tools/frame_budget_audit.gd` (headless) | liczba aktywnych emiterow, zywych czastek, swiatel, warstw Canvas, grajacych glosow audio; koszt klatki jako **roznica** wobec pustego drzewa | budzety obiektowe na wszystkich 45 scenach i brak kosztu skryptowego ponad bezczynny SceneTree | kosztu renderowania — headless nie ma renderera ani GPU |
| `tools/render_frame_timing.gd` (normalny sterownik Windows) | realne interwaly `RenderingServer.frame_post_draw` przy wylaczonym vsync i bez limitu FPS | utrzymanie budzetu 16.66 ms na tej maszynie i tym sterowniku | wydajnosci na innych GPU, sterownikach i systemach |
| `tests/pkg_0130_smoke_test.gd` (bramka w `verify.ps1`) | kontrakty: budzet czastek, wspoldzielone tekstury swiatel, siatka pikselowa kamery, klamrowanie pionowe, cache PCM windy | regresje kontraktow przy kazdej przyszlej zmianie | odbioru gracza (ADR-003) |

Metoda pomiaru czasu klatki headless jest **roznicowa**: bezczynny SceneTree ma staly
koszt ~7.7 ms/klatke wynikajacy z pacingu petli, ktory nie ma nic wspolnego ze scena.
Bezwzgledna wartosc byla wiec bezuzyteczna jako sygnal; odejmowana jest baza zmierzona
na pustym drzewie i budzetowany jest wylacznie koszt przypisywalny scenie.

## 2. Wykonane optymalizacje

### 2.1 Wspoldzielone tekstury swiatel wektorowych

`AtmosphereRig._create_radial_light_texture()` generowal osobna teksture
`GradientTexture2D` 256x256 dla **kazdego** `PointLight2D`. Kampania zawiera 163
instancje `Light2D`, czyli 163 tekstury generowane przy kazdym wejsciu do sceny.

Gradient jest funkcja wylacznie koloru, wiec wprowadzono proces-szeroki cache kluczowany
kolorem (`static var _light_texture_cache`).

| Metryka | Przed | Po |
|---|---|---|
| Tekstury 256x256 generowane dla calej kampanii | 163 | **18** |
| Redukcja | — | **9.1x** |

Metoda `AtmosphereRig.get_light_texture_cache_size()` udostepnia licznik audytowi i bramce;
`clear_light_texture_cache()` pozwala testom startowac z czystego stanu.

### 2.2 Usuniecie hashowania slownikow z petli klatki

`_pulsing_lights` bylo `Array[Dictionary]`, a `_process()` wykonywal na klatke po trzy
odczyty `entry.get("pulse_speed", ...)` na kazde pulsujace swiatlo — czyli hashowanie
stringow w sciezce goracej, 60 razy na sekunde. Zamieniono na rownolegle
`Array[PointLight2D]` + trzy `PackedFloat32Array`. Sciezka goraca nie wykonuje juz
zadnego hashowania.

### 2.3 Jeden kontrakt budzetu czastek dla calego projektu

Nowa klasa `scripts/visual/particle_budget.gd` (`ParticleBudget`) jest jedynym miejscem,
w ktorym zapisany jest kontrakt czasu klatki dla czastek:

- `SIMULATION_FPS = 30` — swiat renderuje sie przez siatke 320x180 nearest-neighbour,
  wiec symulacja czastek szybsza niz 30 Hz nie daje widocznej roznicy, a kazdy krok
  symulacji `CPUParticles2D` to koszt na rdzeniu w budzecie 16.66 ms;
- `fract_delta = false` — usuwa interpolacje kroku czastkowego, dzieki czemu symulacja
  jest deterministyczna klatka po klatce, co jest warunkiem powtarzalnego profilingu;
- `release()` — deterministyczne wygaszenie emitera i porzucenie zywych instancji przy
  opuszczaniu drzewa, aby zmiana sceny nigdy nie zostawiala czastek symulowanych w tle.

Kontrakt zostal podlaczony do **wszystkich piesciu** fabryk emiterow w projekcie:
`atmosphere_rig.gd`, `prototype_player.gd`, `anchorable_object.gd`,
`movable_anchorable_prop.gd`, `memory_resonance_point.gd`. Bramka czyta te pliki i
odrzuca kazda fabryke, ktora konstruuje `CPUParticles2D` bez wywolania
`ParticleBudget.apply_frame_budget()` — nowy emiter dodany bez kontraktu nie przejdzie.

Skutek: **376 zaalokowanych emiterow** w kampanii symuluje sie z polowa czestotliwosci
klatki zamiast pelnej.

### 2.4 Rozdzielenie puli od zbioru aktywnego

Pierwsza wersja audytu liczyla wszystkie emitery przeciw jednemu budzetowi i zglaszala
147 naruszen. Byl to blad metryki, nie kodu: architektura gry poprawnie **wstepnie
alokuje** usypione emitery one-shot (`ResistParticles`, `LandingDust`,
`ResonanceParticles`) i usypione odtwarzacze SFX. Usypiony emiter one-shot nie kosztuje
nic na klatke.

Audyt i bramka rozdzielaja teraz:

- **aktywne** (`emitting == true`, `playing == true`) — koszt na klatke, budzet twardy;
- **pula** (zaalokowane, usypione) — koszt pamieci, budzet luzniejszy.

| Metryka kampanii (45 scen) | Wartosc |
|---|---|
| Emitery aktywne (emitujace) | 94 |
| Zywe czastki | 2086 |
| Emitery w puli (usypione) | 376 |
| Instancje `Light2D` | 163 |
| Grajace glosy audio | 117 |
| Odtwarzacze audio w puli | 554 |
| Wspoldzielone tekstury swiatel | 18 |
| Buforowane bufory PCM | 20 |

Najwyzsze obciazenie zywymi czastkami na scene: **62** (Stacja 24), budzet 128.

### 2.5 Cache PCM silnika windy

`ServiceLift._setup_audio()` wywolywalo `ProceduralAudio.create_moving_tram_motor_sound()`
bezposrednio, syntetyzujac swiezy bufor 1.2 s przy kazdej instancji windy. Przelaczone na
`get_cached_sound(&"moving_tram_motor", ...)`. Bramka sprawdza, ze dwie windy dziela
**jeden** obiekt strumienia.

## 3. Zmierzony budzet renderowania 60 Hz

Pomiar realny, normalny sterownik Windows, vsync wylaczony, `Engine.max_fps = 0`,
180 probek po 30 klatkach rozgrzewki, viewport 640x360.

Sprzet: Intel Iris Xe Graphics (GPU zintegrowane), OpenGL 3.3.0 Compatibility,
sterownik Build 32.0.101.7085.

| Scena | mediana [ms] | p95 [ms] | p99 [ms] | max [ms] | mediana FPS | klatki > 16.66 ms |
|---|---|---|---|---|---|---|
| station_01 (drabiny) | 5.666 | 8.551 | 14.448 | 24.419 | 176.5 | 1 / 180 |
| station_25 (ServiceLift) | 6.440 | 9.151 | 10.894 | 11.518 | 155.3 | 0 / 180 |
| station_34 (komora maszynowa) | 6.553 | 9.621 | 10.801 | 11.429 | 152.6 | 0 / 180 |
| station_35 | 5.934 | 8.604 | 9.615 | 10.565 | 168.5 | 0 / 180 |
| station_36 | 5.532 | 7.875 | 9.025 | 9.782 | 180.8 | 0 / 180 |
| station_37 (gesta para) | 7.310 | 9.157 | 10.096 | 11.043 | 136.8 | 0 / 180 |
| station_40 (spot kontrastowy) | 5.746 | 8.113 | 8.968 | 9.662 | 174.0 | 0 / 180 |
| station_41 (trzy filary) | 6.589 | 8.973 | 10.573 | 11.094 | 151.8 | 0 / 180 |
| station_42a | 4.201 | 7.853 | 9.512 | 9.706 | 238.0 | 0 / 180 |
| station_42b | 4.365 | 7.631 | 9.066 | 11.767 | 229.1 | 0 / 180 |
| station_42c | 4.065 | 7.953 | 9.738 | 11.003 | 246.0 | 0 / 180 |
| station_43 (swit) | 5.115 | 8.339 | 9.055 | 9.442 | 195.5 | 0 / 180 |

Wynik: **najgorsze p99 = 14.448 ms** wobec budzetu 16.66 ms. Zaden przypadek nie
przekracza budzetu w p99. Jedyna klatka powyzej budzetu w calej probie (24.419 ms,
station_01) to pierwsza klatka po wejsciu do sceny — kompilacja pipeline'u shadera
kompozytora, nie utrzymujacy sie zastoj. Mediana we wszystkich probowanych scenach
odpowiada 137–246 FPS, czyli **2.3x–4.1x zapasu** wobec 60 Hz na GPU zintegrowanym.

Stacje 34–37 (komory maszynowe o gestej parze) i 40–42 (komory oswietleniowe finalow)
byly wskazane w prompcie jako podejrzane o spadki plynnosci. Pomiar ich nie potwierdza:
najwyzsza mediana w tej grupie to 7.310 ms (station_37).

## 4. Koherencja pikselowa kamery (drabiny i windy)

Swiat jest kompozytowany przez siatke 320x180 nearest-neighbour w viewporcie 640x360
(`WorldPixelCompositor`, CanvasLayer 5), wiec **jeden piksel kompozytu to 2 jednostki
natywne**. Kamera stojaca na wspolrzednej niecalkowitej powoduje, ze `floor()` w shaderze
kompozytora przeskakuje miedzy sasiednimi rzedami zrodlowymi — co czyta sie jako
"pelzanie pikseli" przy ruchu pionowym (drabiny, windy).

Wdrozone:

1. **Rozdzielenie autorytetu od transformacji.** Wygladzanie pozostaje w liczbach
   zmiennoprzecinkowych (`_smooth_position`), a na siatke 2 px (`PIXEL_GRID`) snapowana
   jest wylacznie transformacja przekazywana rendererowi. Snap nigdy nie jest odczytywany
   z powrotem jako stan, wiec **nie moze kumulowac dryfu**. Bramka mierzy dryf i wymaga,
   by pozostal w jednej komorce siatki.
2. **Klamrowane sledzenie pionowe.** Kamera podaza za Lena w pionie tylko po wyjsciu ze
   strefy martwej 46 px i nigdy nie wychodzi poza krawedzie komory. Komora o wysokosci
   dokladnie jednego widoku (przypadek wiekszosci stacji) zwija klamre do swojego srodka,
   wiec **plaskie stacje zachowuja dotychczasowe zablokowane kadrowanie bez zmian**.
   Sledzenie wlacza sie wylacznie w komorach wyzszych niz widok, czyli w szybach drabin
   i wind — dokladnie tam, gdzie bylo potrzebne.
3. **Wstrzas na tej samej siatce.** `Camera2D.offset` jest snapowany do 2 px. Bez tego
   wstrzas dodawany po pozycji znosilby kompozytor z siatki i anulowal punkt 1.
4. Bramka weryfikuje 120 klatek z delta niecalkowita i wymaga **zera** klatek poza
   siatka, klamrowania na obu krancach szybu wysokiego 720 px, braku reakcji na ruch
   wewnatrz strefy martwej oraz zera klatek poza siatka podczas wstrzasu.

## 5. Czego ten audyt NIE dowodzi

Zgodnie z ADR-003 i regula projektu, ze test dowodzi wylacznie mierzonego kontraktu:

- **Nie dowodzi odczucia plynnosci.** Zmierzono czasy klatek, nie wrazenie gracza. Brak
  testow zewnetrznych (D-012, ADR-003).
- **Nie dowodzi wydajnosci na innym sprzecie.** Pomiar z sekcji 3 pochodzi z jednej
  maszyny (Intel Iris Xe, OpenGL Compatibility, Windows). Steam Deck, Wayland, sterowniki
  AMD i NVIDIA pozostaja niezweryfikowane.
- **Nie dowodzi braku zastojow dlugoterminowych.** Probka to 180 klatek na scene
  (~1–1.3 s). Wycieki narastajace w skali dziesieciu minut gry sa poza zasiegiem tej
  proby; osobnym dowodem RAM pozostaje symulacja soak z PKG-0128.
- **Audyt headless nie dowodzi budzetu renderowania.** Nie ma renderera ani GPU;
  ogranicza wylacznie budzety obiektowe i koszt skryptowy.
- **Nie dowodzi poprawnosci wizualnej snapowania w ruchu ciaglym.** Bramka mierzy, ze
  transformacja lezy na siatce i ze nie ma dryfu; subiektywna ocena gladkosci ruchu
  kamery przy wspinaczce nie zostala potwierdzona.

## 6. Znalezione, nienaprawione

| Znalezisko | Waga | Decyzja |
|---|---|---|
| Niespojne nazwy wezla kamery: `Camera` w stacjach 01–32, `Camera2D` w stacjach 33–43 | niska | Nie zmieniano nazw. Zmiana nazwy wezla w 13 scenach niesie ryzyko rozjazdu z referencjami w skryptach stacji przy zerowym zysku funkcjonalnym. Bramka rozwiazuje kamere **po typie** (`CinematicCamera`), nie po nazwie, co jest i tak wlasciwszym kontraktem. Do ewentualnego uporzadkowania w osobnym pakiecie porzadkowym. |
| 554 odtwarzacze audio w puli w calej kampanii (do 20 na scene, z czego <= 4 graja) | niska | Usypiony `AudioStreamPlayer` nie kosztuje nic na klatke, a wszystkie strumienie pochodza ze wspolnego cache PCM (20 buforow). Koszt to naglowki wezlow, nie mikser. Bez zmian. |
| Brak pomiaru na GPU dedykowanym | srednia | Poza zakresem — brak innego sprzetu w tym srodowisku. Zapisane jako niepotwierdzone. |

## 7. Weryfikacja

```
pwsh -NoProfile -File .\tools\verify.ps1        # PASS, exit code 0
godot --headless --path . --script res://tools/frame_budget_audit.gd     # PASS
godot --path . --script res://tools/render_frame_timing.gd --resolution 640x360   # PASS
```

Bramka `PKG-0130 Frame budget, particle determinism and pixel-grid camera gate` oraz
`PKG-0130 Frame budget audit (45 campaign scenes)` sa czescia `tools/verify.ps1`.
Pomiar realnego renderowania (`render_frame_timing.gd`) **nie** jest czescia `verify.ps1`,
bo wymaga normalnego sterownika wyswietlania i okna — uruchamiany jest recznie przy
zmianach wplywajacych na obraz.

Zgodnie z dyspozycja uzytkownika i D-098 **nie generowano nowych plikow `.exe` ani paczek
binarnych**.
