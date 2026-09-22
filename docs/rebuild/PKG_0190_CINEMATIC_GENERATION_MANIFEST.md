# PKG-0190 — Manifest generacji gen-ai dla cinematic vignettes

Status: kompletny rejestr wszystkich finalnych plików pod `assets/cinematics/`.
Model: **Flux Kontext Max** (Picsart AI, tool `picsart_generate`, `model: "flux-kontext-max"`),
`aspectRatio: "16:9"`, `count: 1` na wywołanie. Brak lokalnych kluczy API w tym
repozytorium — generacja wykonana przez połączone narzędzie MCP tej sesji.

## 1. Referencja tożsamości

Jedyna referencja obrazu użyta we wszystkich wywołaniach z Leną: portret
kanoniczny `assets/characters/portraits/lena.png` (1024×1024, PKG-0136/0186),
przeskalowany offline do 192×192 i zapisany jako JPEG q72 wyłącznie w celu
zmieszczenia się w limicie transferu narzędzia; sam plik kanoniczny w
repozytorium **nie został zmieniony**. Karta tożsamości Leny (`CAST_AND_NPC_BIBLE.md`
§2.1) była powtarzana dosłownie w każdym prompt z jej udziałem: *"Lena Wolska,
29-year-old vibration diagnostics technician. Short dark angular bob haircut,
adult woman's face, cool green work coverall/jacket, a bright seam patch on
the left sleeve, an asymmetric field bag across her body. Closed guarded
posture, arms close to the body. Match the exact face and proportions of the
attached reference image exactly — do not redesign her."*

Marta, Jakub i inne postacie **nie występują** w żadnej z pięciu sekwencji —
zgodnie z audytem placementu (`PKG_0190_CINEMATIC_PLACEMENT.md`) każda winieta
pokazuje wyłącznie Lenę i/lub nieczytelne sylwetki za matową szybą (dozwolony
wyjątek §1 `CAST_AND_NPC_BIBLE.md`). To wyeliminowało potrzebę jakiejkolwiek
dodatkowej referencji postaci.

## 2. Wspólny blok stylu i negative prompt

Każde wywołanie kończyło się identycznym blokiem stylu (cytowany raz, nie
powtarzany w tabeli niżej dla zwięzłości):

> Style: flat screen-print poster illustration, solid flat color fills only,
> hard-edged cel shading with exactly one sharp hard highlight shape per
> surface, NO soft gradients anywhere, NO smooth airbrush blending, NO glossy
> render, thick confident bold outlines, large near-black graphite shadow
> masses covering most of the frame, high contrast, graphic silhouette-first
> staging, at most 8 to 12 total flat colors in the whole image with at most
> two saturated accent hues. Base palette: near-black graphite and deep navy
> for shadow mass; cool turquoise reserved only for active measurement
> circuits; warm amber reserved only for the current warm light source;
> muted oxidized red reserved only for irreversible cost or danger; dirty
> off-white reserved only for public documents/light. Absolutely no text, no
> letters, no numbers, no glyphs, no logos, no UI elements, no
> screen-readable text of any kind. Not in the visual style of any specific
> living artist.

Negative prompt (baza, rozszerzana per-kadr o konkretne ryzyko tekstu):
`soft gradient, airbrush shading, smooth blending, glossy skin, photorealistic
rendering, painterly brushwork, 3D render, ambient occlusion glow, subtle
color transitions, text, letters, words, numbers, glyphs, subtitles,
captions, UI, HUD, logo, watermark, signature, blur, motion blur, film grain,
random dither noise, neon glow, cyberpunk aesthetic, low poly, glitch
artifacts, distorted anatomy, extra limbs, extra fingers, second face,
different character face, doubled Lena, cropped face, deformed hands, jpeg
compression artifacts, comic book ink cross-hatching, imitation of a specific
living artist's style`.

Ten blok wyprowadzono empirycznie: pierwsza próba (bez „flat screen-print
poster / hard-edged / NO soft gradients") dała miękkie, malarskie cieniowanie
niezgodne z `VISUAL_DESIGN.md` §7 — odrzucona, nie trafiła do assetów.
Widoczna w `reports/pkg_0190/cinematics/rejected_vig01_f1_soft_v1.png` (patrz
§5).

## 3. Tabela finalnych plików

| Plik finalny | Winieta / klatka | Trigger stacji | Prompt (skrót sceny — pełny w kodzie promptu §4) | Ręczna poprawka |
|---|---|---|---|---|
| `assets/cinematics/vig_threshold/frame_0.png` | VIG-01 „Próg", klatka 1 | `station_08.apartment_fourteen_unlocked` | Ręka Leny obraca klucz w zamku drzwi 14, ciepłe światło zza uchylonych drzwi | resize+center-crop 640×360 (LANCZOS) |
| `assets/cinematics/vig_threshold/frame_1.png` | VIG-01, klatka 2 | jw. | Lena nieruchomo w progu, twarz w podzielonym świetle ciepło/zimno | jw. |
| `assets/cinematics/vig_synthesis/frame_0.png` | VIG-02 „Synteza", klatka 1 | `station_13` (nowy sygnał `world_difference_synthesized`) | Trzy dowody (przyrząd, dokument, dyktafon) ułożone razem na biurku pod dłońmi Leny | jw. + wersja 2 (v1 miała nieczytelny pseudo-tekst na dokumencie — odrzucona, patrz §5) |
| `assets/cinematics/vig_synthesis/frame_1.png` | VIG-02, klatka 2 | jw. | Zbliżenie na twarz Leny, opanowana nieruchomość, ciepły poblask drzwi za nią | jw. (resize) |
| `assets/cinematics/vig_signal/frame_0.png` | VIG-03 „Sygnał", klatka 1 | `station_15.mutual_signal_test_completed` | Czysty abstrakcyjny przebieg z korektą, bez cyfr, ekran przyrządu | jw. |
| `assets/cinematics/vig_signal/frame_1.png` | VIG-03, klatka 2 | jw. | Lena wstrzymuje oddech przy konsoli, turkusowy poblask od dołu | jw. |
| `assets/cinematics/vig_commit/frame_0.png` | VIG-04 „Zatwierdzenie", klatka 1 | `station_18.method_committed` | Dłoń Leny naciska jeden z trzech znaczników słupka zatwierdzenia, latarnia uliczna | jw. + wersja 2 (v1 miała nieczytelny pseudo-tekst na łacie rękawa — odrzucona, patrz §5) |
| `assets/cinematics/vig_commit/frame_1.png` | VIG-04, klatka 2 | jw. | Lena odchodzi od słupka w stronę oświetlonej witryny | jw. + wersja 2 + **ręczne domalowanie** prostokąta (58,46,30) na fasadzie witryny w oryginalnej rozdzielczości (`[870,120]-[1392,195]`) przed przeskalowaniem — v2 nadal miała ślad nieczytelnego tekstu na markizie witryny |
| `assets/cinematics/vig_finale_a/frame_0.png` | FINALE-A (`ending_family=force_home`), klatka 1 | `station_42a.household_consequence_read` | Puste krzesło i zimny kubek przy stole, zapieczętowane drzwi w tle | resize |
| `assets/cinematics/vig_finale_a/frame_1.png` | FINALE-A, klatka 2 | jw. | Lena sama przy stole, patrzy na puste krzesło | resize |
| `assets/cinematics/vig_finale_b/frame_0.png` | FINALE-B (`ending_family=close_equal_recover_local`), klatka 1 | `station_42b.household_consequence_read` | Ciepła nieczytelna sylwetka za matową szybą progu | resize |
| `assets/cinematics/vig_finale_b/frame_1.png` | FINALE-B, klatka 2 | jw. | Lena w progu wyjścia, ciepło mieszkania za nią, zimna ulica przed nią | resize |
| `assets/cinematics/vig_finale_c/frame_0.png` | FINALE-C (`ending_family=mutual_passage`), klatka 1 | `station_42c.household_consequence_read` | Dwa czytniki z identycznym przebiegiem i tą samą luką, bez cyfr | resize + wersja 2 (v1 miała czytelne cyfry osi — odrzucona, patrz §5) |
| `assets/cinematics/vig_finale_c/frame_1.png` | FINALE-C, klatka 2 | jw. | Lena przy stole, druga, nieczytelna ciepła sylwetka za szybą na drugim krześle | resize |

## 4. Pełne prompty per klatka

Pełna treść promptu (scena/kamera/funkcja kadru/światło/zachowanie/stan
narracyjny) dla każdej z 14 klatek jest zachowana w historii wywołań tej
sesji i odtworzona w kodzie jako komentarz w
`scripts/cinematics/cinematic_catalog.gd` przy odpowiednim wpisie manifestu —
jedno źródło prawdy zamiast duplikowania ~9000 znaków promptów w dwóch
miejscach. Skrót sceny na klatkę jest w tabeli §3.

## 5. Odrzucone warianty robocze (nie trafiły do assetów)

Cztery klatki wymagały drugiej (lub w jednym przypadku trzeciej) generacji
zanim spełniły twardy zakaz tekstu (`VISUAL_DESIGN.md` §7) lub styl płaskiego
cieniowania:

1. `vig01_f1` wersja 1 — zbyt miękkie, malarskie cieniowanie (brak „hard-edged
   cel shading" w pierwszym promptcie). Odrzucona przed jakąkolwiek oceną
   tekstu.
2. `vig02_f1` wersja 1 — nieczytelny pseudo-tekst „MAGSHREOMENT" i linia
   podpisu na dokumencie. Naprawiona przez jawny zakaz `no printed text, no
   ink marks, pure blank flat-colored paper only` w promptcie dokumentu.
3. `vig04_f1` i `vig04_f2` wersja 1 — nieczytelny pseudo-tekst wyhaftowany na
   łacie rękawa Leny. Naprawiona przez zmianę opisu łaty na „plain
   solid-color rectangular fabric patch... with absolutely no text or marks".
   `vig04_f2` wymagała dodatkowo ręcznej poprawki offline (§3) — nawet wersja
   2 zostawiła ślad tekstu na markizie sklepu w tle.
4. `finaleC_f1` wersja 1 — czytelne cyfry na osiach dwóch ekranów oscyloskopu
   (`0 1 2 3…`, `150 100 1 -30…`). Naprawiona przez jawny zakaz `no grid
   lines, no axis, no tick marks, and no numbers of any kind`.

Robocze pliki (wersje odrzucone i zaakceptowane przed normalizacją) leżały
wyłącznie w katalogu roboczym sesji poza projektem
(`%TEMP%/claude/.../scratchpad/cinematics_draft/`), zgodnie z wymogiem
„najpierw warianty robocze poza końcowym katalogiem assetów". Do
`assets/cinematics/` trafiły wyłącznie finalne, ręcznie zaakceptowane pliki
wymienione w §3.

## 6. Normalizacja offline (deterministyczna)

Skrypt jednorazowy (nie zapisany do `tools/`, uruchomiony ad-hoc w tej
sesji): dla każdej zaakceptowanej klatki — `Image.LANCZOS` skalowanie do
pokrycia 640×360, następnie środkowe przycięcie do dokładnie 640×360 (te same
proporcje 16:9 co logiczny viewport, więc przycięcie jest minimalne, głównie
na krawędziach). Dla `vig_commit/frame_1.png` dodatkowo: prostokąt
`(870,120)-(1392,195)` w oryginalnej rozdzielczości wypełniony kolorem
`(58,46,30)` przed skalowaniem, żeby usunąć ślad tekstu na markizie witryny.
Żaden plik nie przeszedł przez `tools/process_cast_sprites.py` — to nie są
sprite'y postaci na siatce pikseli rigu, tylko pełnoklatkowe plansze
(analogicznie do `assets/cold_open/shot2_rail_hands.png`).

## 7. Koszt

14 wywołań końcowych + 4 poprawki + 2 próby robocze = 20 wywołań
`picsart_generate` (`flux-kontext-max`, `count:1`) łącznie w tej sesji, każde
≈3 kredyty Picsart. Saldo przed sesją: 1340 kredytów; zużycie nieistotne
wobec salda.
