# PKG-0220 — Pętle ambientu + duck (A1+A2 z domieszką A3/A4, faza R4)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0219
(faza R4 planu PKG-0213 §8, findings A1+A2 z domieszką A3/A4). Decyzja D-233.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

## Co zmieniono (shared-touch: audio + rig → pełna verify)

1. Pętle (A1): 7 ambientów PKG-0180 (`viaduct 2.20 / perimeter 2.40 /
   substation 2.20 / vault 2.30 / analyzer 2.20 / ledger 2.10 /
   dawn river 2.60 s`) przechodzi z jednorazowego `generate_wav`
   z obwiednią `sin(progress*PI)*(1-exp(...))` (cisza na końcach co
   2,1–2,6 s + retrigger `finished→play`) na `generate_looping_wav`
   z obwiednią loop-safe (`env := 1.0`). F0 i wewnętrzne AM nietknięte
   (te same częstotliwości i głębokości tremola); długości identyczne.
   `generate_looping_wav` dokłada wypiekany crossfade 80 ms (liniowy
   ogon<-głowa) na szwie pętli — sygnatura bez zmian, więc spis D-225
   stoi (265 staticów). Wcześniejsze pętle całkowito-okresowe
   (sustain 1.20 s, drag 0.80 s) przechodzą bez zmian zachowania.
2. Duck (A2): `_update_ambient_ducking` obejmuje trzeci player
   (`_unease_player`, baza −22 dB, nowa const BASE_UNEASE_VOLUME_DB);
   7 dB i lerp 6.0 bez zmian. Ręczny + automatyczny (CRT/is_presenting
   jako metoda + InnerThoughtSurface.visible) bez zmian.
3. Busy (A3): `_ensure_audio_buses()` zakłada idempotentnie busy
   `Ambient` (tło) i `Dialogue` (rezerwa na sidechain, kompresor
   opcjonalny wg planu); wszystkie 3–4 playery rigu na `Ambient`.
   Ręczny duck pełni rolę sidechainu Dialogue→Ambient. Komentarz:
   ambient celowo niepozycjonowany (zwykły AudioStreamPlayer, mono
   44100; pozycję daje miks, nie panorama; blipy dialogowe grają
   poza rigiem).
4. Double-buffer (A1): `_ambient_back` (`AmbientBackBuffer`) niesie tę
   samą zapętloną instancję co primary (hot spare, −80 dB, bez
   retriggera; natychmiastowe przejęcie bez resyntezy). Retrigger
   `finished→play` usunięty z hum i sub (pętla nigdy nie woła
   `finished`, więc połączenie było wyłącznie źródłem szczeliny).
5. Drain (A4): `_exit_tree` zastąpiony jednym
   `ProceduralAudio.drain_playback(self)` (idempotentny, obejmuje
   też back-buffer); teardown cząstek bez zmian.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0220_ambient_loop_duck_test.gd` PASS:
  statyka (7× looping + env 1.0 + markery f0 + census 265 + wiring
  rigu + brak retriggera), runtime pętli (PCM + LOOP_FORWARD +
  długość ±0.02 s + RMS krawędzi > 500 + szew < 12000 + sustain/drag
  stoją), kontrola fail-closed (one-shot LOOP_DISABLED), duck ×3
  (≥ 5 dB w dół, powrót), busy Ambient/Dialogue, back-buffer
  (ta sama instancja, brak retriggera, rig stacji 02 z pętlą na żywo),
  drain idempotentny (2×, cache nietknięty, double clear czysty).
- Pin `pkg_0207`: 114/113/112 po aktualizacji (reguła D-222);
  121. sekcja w `tools/verify.ps1`.
- Sąsiedzi bez dotykania: `pkg_0211` (census 265) PASS,
  `pkg_0180` (generatory + duck −24/−28) PASS, `pkg_0126/0127/0139`
  (rig lifecycle) PASS, `pkg_0219` PASS.
- PEŁNA `tools/verify.ps1` PASS (limit D-217: obowiązkowa w tym pakiecie;
  poprzednia pełna PKG-0215, zakresowe 0216/0217/0218/0219).

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (pętle, RMS krawędzi,
duck 3 playerów, busy, back-buffer, drain), nie braku słyszalnego
kliknięcia na każdym sprzęcie ani odbioru (D-012, ADR-003). Odsłuch
A/B opisany w handoffie jako obserwacja, nie dowód. Start stacji
zaczyna pętlę od pełnego poziomu (bez fade-in stacji) — pojedynczy
transjent wejścia możliwy, maskowany poziomem −24 dB; nie mierzono
go bramką. Ambients spoza 7 (hum/rain/bus/residential/corridor/hvac/
teletype/tunnel/…) zostają na one-shot + retrigger poza zakresem
tego pakietu. Ekstrakcja tabel MRP (krok 2) nadal wymaga oddzielnej
dyspozycji (shared-touch → pełna verify).
