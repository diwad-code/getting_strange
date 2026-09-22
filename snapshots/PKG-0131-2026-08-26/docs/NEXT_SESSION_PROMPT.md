# Prompt nastepnej sesji: PKG-0132

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu. Decyzje D-121..D-126 SA JUZ PODJETE — nie pytaj,
wykonuj. Wlasciciel przekazal Ci ster i zabronil stopow.

CEL SESJI: PKG-0132 — Lena 4.0 (kobieta, nie krasnoludek) + jedna skala swiata
+ dwukierunkowe lokacje + skok nie jest lokomocja + drabiny/windy wszedzie
tam, gdzie sciana jest za wysoka.

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f, Windows, PowerShell/pwsh.
- Brak Gita; stan wylacznie na dysku (D-016).
- Ostatni zamkniety pakiet: PKG-0131 (przekierowanie kanonu, bez runtime).
- Poprzedni runtime: PKG-0130, verify PASS, p99 14.448 ms.
- BEZWZGLEDNY ZAKAZ nowych .exe i paczek binarnych (D-125). Wlasciciel sam
  powie, kiedy budowac. Snapshot zostaje.
- Weryfikacja bazowa na starcie: pwsh -NoProfile -File .\tools\verify.ps1
- Czytaj w kolejnosci: AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md,
  TEN PLIK, docs/WORLD_SCALE.md, docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md,
  docs/LENA_CHARACTER_AND_ANIMATION.md §1 i §10,
  docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md,
  scripts/player/lena_visual_rig.gd, scenes/player/prototype_player.tscn,
  scripts/environment/ladder_zone.gd, scripts/core/game_state_manager.gd
  (previous_level_requested / target_spawn_side).

FAKTY Z DYSKU (nie zgaduj, to zmierzono w PKG-0131):
1. LenaVisualRig._draw() = proceduralne wielokaty. Capsule 56x12. Figura ~66 px.
   Wlasciciel: wyglada tragicznie, nie jak kobieta, jak krasnoludek.
2. ZERO stacji emituje signal previous_level_requested. GSM go slucha.
   Dlatego da sie isc tylko w prawo.
3. geometry_audit.gd uzywa progu 35 px. To blat, nie schodek. Nowy prog = 18 px.
4. LadderZone i ServiceLift istnieja. Uzywaj ich, nie wymyslaj trzeciego systemu.
5. CLI: gen-ai (Picsart). Skille: gen-ai-use, text-to-visual. KORZYSTAJ SMIALO
   do Leny I do mebli / tla, byle paleta Rowien Pixel-Stage i skala WORLD_SCALE.

DECYZJE JUZ PODJETE:
- D-121 P6 = Human Scale & Playability. Kamera/reduced-motion ODROCZONE.
- D-122 Lena 4.0 = sprite z gen-ai, nie _draw() wielokatow.
- D-123 Skok nie jest lokomocja. Sciana za wysoka = drabina albo winda.
- D-124 Kazda stacja 02-43 ma lewe wyjscie emitujace previous_level_requested.
- D-125 Zero .exe.
- D-126 1 m = 52 px. Lena stojaca = 87 ± 3 px. Krzeslo-czlowiek = blad.

KOLEJNOSC WYKONANIA (jak najwiecej w TEJ sesji; nie stopuj miedzy fazami):

FAZA A — Lena 4.0 (najpierw, bo jest linijka):
- gen-ai whoami; gen-ai models; wybierz model obrazu (nie wideo).
- Karta: 36-letnia polska inzynierka IKP, krotki klin ciemnych wlosow,
  twarz doroslej kobiety, biodra i talia, jasny szew lewego rekawa,
  asymetryczna torba, laboratoryjny prochowiec, NIE chibi, NIE krasnoludek,
  NIE Lester / Another World, NIE anime-loli.
- Osobne wywolania: idle, walk x4-8, run x4-6, jump_rise, jump_fall, land,
  climb, interact, examine. Zakaz jednej siatki model-sheet.
- gen-ai remove-bg. Wspolna baseline stopy. Wysokosc stojaca 87 ± 3 px.
- assets/characters/lena/ + import nearest, bez mipmap.
- LenaVisualRig wyswietla Sprite2D/AnimatedSprite2D. 14 nazw stanow zostaje.
  _draw() tylko cien kontaktowy. PrototypePlayer: kapsula wysokosc 72, r=8.
- Capture Station 01: Lena obok krzesla i drzwi. Test WORLD_SCALE §4.
  Jesli krasnoludek — odrzuc i generuj ponownie. Nie zamykaj fazy na
  „wystarczy, bo test przeszedl”.

FAZA B — jedna skala we wszystkich 43 stacjach:
- Audyt kazdej sceny: krzeslo, stol, drzwi, lozko, ladunek vs Lena 87 px.
- Zmniejsz rysunek mebla-olbrzyma. Drzwi ~109 px. Siedzisko krzesla ~23 px.
  Stol ~39 px. Zakaz scale na rootcie sceny.
- Wolno uzyc gen-ai do nowych sprite'ow mebli.
- Wypelnij kolumne „Mebel-olbrzym” w PLAYTHROUGH_TRAVERSAL_AUDIT.md.

FAZA C — prawo I lewo:
- Wspolny maly komponent ReturnZone (Area2D na lewej krawedzi, x maly).
  Po wejsciu gracza emituje previous_level_requested na korzeniu stacji.
- Dodaj signal previous_level_requested do kazdej stacji 02-43
  (w tym 42a/42b/42c). Stacja 01 NIE wraca do tytulu lewa krawedzia.
- GSM juz robi spawn po prawej przy target_spawn_side == &"right".
  Sprawdz _apply_spawn_side_deferred i popraw, jesli gracz spawnuje sie
  w scianie.
- Gracz musi moc wracac 05→04→03 pieszo w lewo.

FAZA D — przejscie + drabiny/windy (to, o co wlasciciel prosil w pkt 5):
- Obniz prog w tools/geometry_audit.gd z 35.0 na 18.0.
- Uruchom audyt. Kazdy blocker = LadderZone albo ServiceLift przy tej
  scianie, diegetycznie umocowany (R7). Nazwa ze swiata, nie Platform.
- Sprobuj przejsc kampanie (headless geometria + sterowany przebieg
  albo capture sekwencyjny). Oznacz w PLAYTHROUGH_TRAVERSAL_AUDIT.md
  miejsca, ktorych nie da sie pokonac pieszo.
- Skok zostaje w InputMap, ale ZADNA wymagana trasa miejska nie moze
  wymagac skoku na wysokosc > 18 px.
- Zakaz arcade: D-099. Maszyna pracuje, bo jest maszyna.

FAZA E — bramka, dokumenty, snapshot:
- tests/pkg_0132_smoke_test.gd:
  * LenaVisualRig nie rysuje ciala wielokatami (albo rysuje wylacznie cien);
  * wysokosc visual w zakresie 84–90;
  * kapsula 72;
  * kazda stacja 02-43 ma signal previous_level_requested;
  * geometry_audit prog 18 i 0 blockerow bez drabiny/windy;
  * zero nowych .exe w drzewie od startu pakietu.
- Podlacz do tools/verify.ps1.
- Capture normalnym driverem: Station 01, 05, 07, 14, 25, 34 (Lena + mebel).
- Aktualizacja CURRENT_STATE, ROADMAP, RISKS, SESSION_LOG, NOWY prompt.
- Jesli nie domkniesz wszystkich 43 stacji: zostaw jasna reszte w
  PLAYTHROUGH_TRAVERSAL_AUDIT i napisz PKG-0133 TYLKO na reszte.
  Nie udawaj 100%, jesli tabela ma OPEN.
- Snapshot: pwsh -NoProfile -File "tools/snapshot.ps1" -Package PKG-0132
  (cudzyslow, bo Git Bash zjada backslashe).
- NIE tworz .exe.

KRYTERIA AKCEPTACJI:
1. W kadrze Station 01 Lena czyta sie jako dorosla kobieta obok krzesla
   i drzwi. Krzeslo nie jest jej wzrostu. To weryfikujesz okiem na swiezym
   PNG, nie asercja liczaca linie kodu.
2. Z zadnej wymaganej trasy miejskiej nie trzeba skakac na sciane.
   Kazdy stopien > 18 px ma drabine albo winde.
3. Ze stacji 05 da sie wrocic do 04 i 03, idac w lewo. Spawn nie w scianie.
4. Tabela PLAYTHROUGH_TRAVERSAL_AUDIT ma status inny niz OPEN dla kazdej
   stacji, ktora twierdzisz ze zrobiles.
5. verify.ps1 exit 0. Zero nowych .exe.

POZA ZAKRESEM:
- web, PWA, HTML (D-098);
- nowe czasowniki ruchu (dash, wall-jump, kucanie-akrobacja);
- arcade (kolce, patrole, paski zdrowia, ruchome platformy-cele skoku);
- unifikacja nazwy Camera vs Camera2D;
- reduced-motion;
- eksport binariow;
- przepisywanie fabulu 0.3.

KONIEC PAKIETU JEST OBOWIAZKOWY:
1. Aktualizacja CURRENT_STATE.md, ROADMAP.md, RISKS_AND_HYPOTHESES.md,
   SESSION_LOG.md, PLAYTHROUGH_TRAVERSAL_AUDIT.md.
2. Nowy prompt w NEXT_SESSION_PROMPT.md (PKG-0133 tylko jesli zostala
   reszta; w przeciwnym razie nastepny sensowny szlif P6).
3. Snapshot PKG-0132.
4. Raport: testy, ograniczenia, numer pakietu, sciezka handoffu.
   Nie pisz, ze „gra jest fajna”. ADR-003.
```
