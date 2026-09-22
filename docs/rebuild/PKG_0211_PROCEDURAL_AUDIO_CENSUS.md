# PKG-0211 — Spis i pin silnika syntezy ProceduralAudio (zero logiki, zero obrazu)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0210) z decyzją
podjętą autonomicznie w ramach orkiestracji AI (/ai-team-orchestration, D-025, D-085, ADR-004).
Ścieżka B (`station_18 prop_type`) jest ZAMKNIĘTA decyzją D-220. Ścieżka C (ogląd 85/115)
jest DOMKNIĘTA (0202 + 0203). Ścieżka A (ekstrakcja tabel MRP) dotyka współdzielonego monolitu;
Ścieżka D dostarcza autorytatywny spis, audyt architektoniczny i kontrakt techniczny audio.
Ten dokument jest diagnozą techniczną wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **jakie są dokładne parametry i metryki silnika syntezy proceduralnego
audio (`ProceduralAudio`), ile generatorów fali dźwiękowej zawiera, czy generowane strumienie
spełniają nienaruszalny kontrakt 16-bit PCM 44.1 kHz mono, jak zachowuje się pamięć podręczna
`_sound_cache` i procedura `drain_playback` zapobiegająca wyciekom ObjectDB na platformie Windows?**

## Decyzja D-225: spis + pin, HOLD logiki i obrazu

Silnik `ProceduralAudio` zostaje ZAPINOWANY nową bramką spisu i testów kontraktowych,
a parametry formatu fal, pętli i cyklu życia bufora pamięci podręcznej OPISANE pinami read-only.
Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs, routingu, progach i InputMap;
nowe pliki wyłącznie: ten raport, bramka `tests/pkg_0211_procedural_audio_census_test.gd`,
rejestracja bramki w `tools/verify.ps1` (106. wywołanie Invoke; 113. sekcja w verify.ps1) oraz
kontrolowana aktualizacja pinu `tests/pkg_0207_gate_census_test.gd` (105->106 wywołań, 104->105 skryptów,
103->104 testów w verify, 103->104 testów na dysku). D-168, D-220..D-224 obowiązują bez zmian.

## Inwentaryzacja i pomiary (stan na dysku, narzędzie: odczyt tekstu + runtime)

### Spis funkcji i struktury `scripts/audio/procedural_audio.gd` (4108 linii)

- Typ bazowy: `class_name ProceduralAudio extends RefCounted`.
- Wszystkie metody są czysto statyczne (`static func`).
- Liczba funkcji statycznych łącznie: **265**.
- Liczba generatorów dźwięków `create_*`: **256**.
  - Generatorów bezparametrowych (`() -> AudioStreamWAV`): **250**.
  - Generatorów sparametryzowanych: **6**:
    1. `create_land_sound(is_metal: bool = false)`
    2. `create_dialogue_blip_sound(is_lena: bool = true)`
    3. `create_crosswalk_signal_sound(with_name_whisper: bool = false)`
    4. `create_bus_engine_sound(is_decelerating: bool = false)`
    5. `create_surface_land_sound(surface_type: int)`
    6. `create_dialogue_blip_for_speaker(speaker: Variant)`
- Liczba funkcji pomocniczych i infrastruktury: **9**:
  1. `get_cached_sound(cache_key: StringName, generator_callable: Callable) -> AudioStreamWAV`
  2. `clear_sound_cache() -> void`
  3. `drain_playback(node: Node) -> void`
  4. `_stop_player(player: AudioStreamPlayer) -> void`
  5. `_stop_player_2d(player: AudioStreamPlayer2D) -> void`
  6. `_stop_player_3d(player: AudioStreamPlayer3D) -> void`
  7. `get_sound_cache_size() -> int`
  8. `generate_wav(duration: float, generator_func: Callable) -> AudioStreamWAV`
  9. `generate_looping_wav(duration: float, generator_func: Callable) -> AudioStreamWAV`

### Kontrakt techniczny generowanych fal PCM

Każdy wygenerowany strumień dźwiękowy spełnia stały zestaw reguł fizycznych:
- Typ obiektu: `AudioStreamWAV`.
- Format: `AudioStreamWAV.FORMAT_16_BITS` (16-bit signed PCM).
- Częstotliwość próbkowania: `44100` Hz (`const SAMPLE_RATE = 44100`).
- Kanały: `stereo = false` (czyste mono; pozycjonowanie przestrzenne realizują AudioStreamPlayer2D).
- Bufor danych: `data.size() > 0` oraz `data.size() % 2 == 0` (parzysta liczba bajtów odpowiadająca próbkom 16-bit little-endian).

### Dźwięki zapętlone (`generate_looping_wav`)

Dwa generatory w systemie wytwarzają ciągłe dźwięki proceduralne ze znacznikami zapętlenia:
- `create_anchor_sustain_tone_sound()`
- `create_prop_drag_scrape_sound()`
Dla obu generatorów bramka dowodzi parametrów pętli:
- `loop_mode == AudioStreamWAV.LOOP_FORWARD`
- `loop_begin == 0`
- `loop_end > 0` (koniec bufora próbkowania).

### Pamięć podręczna `_sound_cache`

- `get_cached_sound(cache_key, generator)` zapewnia referencyjną równość (`stream1 == stream2`) przy kolejnych zapytaniach o ten sam klucz, eliminując alokację PCM i syntezę CPU w czasie rozgrywki.
- `clear_sound_cache()` opróżnia słownik `_sound_cache`, zwalniając pamięć RAM podczas przejść między stacjami (`GameStateManager.transition_to_scene()`).
- Bramka weryfikuje poprawność cyklu życia i brak re-ewaluacji callables przy cache hit.

### Oczyszczanie odtwarzaczy (`drain_playback`)

- Rekursywnie przeszukuje drzewo węzłów i dla każdego `AudioStreamPlayer`, `AudioStreamPlayer2D` oraz `AudioStreamPlayer3D`:
  - odłącza sygnały zapętlenia (`player.finished.disconnect(player.play)`),
  - wywołuje `player.stop()`,
  - ustawia `player.stream = null`.
- Zapewnia natychmiastowe zwolnienie zasobów audio przez backend WASAPI w Godot 4.7 na Windows i zapobiega wyciekom ObjectDB przy niszczeniu scen.

## Wynik weryfikacji bramkowej

- Nowa bramka `tests/pkg_0211_procedural_audio_census_test.gd` PASS headless.
- Zaktualizowany rejestr pinu `tests/pkg_0207_gate_census_test.gd` PASS (106 invokes / 105 scripts / 104 tests).
- Weryfikacja zakresowa `tools/verify_scoped.ps1` (docs + smoke 01..43 + 0206 + 0207 + 0208 + 0210 + 0211) PASS.
- Exit code 0, zero błędów i ostrzeżeń.
