# PKG-0219 — Sufit + światło + reguła różu 09/01 (V4+V6+V10, faza R3)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0218
(faza R3 planu PKG-0213 §8, findings V4+V6+V10). Decyzja D-232.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Co zmieniono (sceny lokalne 01/09 + decyzja, zero mechaniki)

1. Sufit (V4): podbitka 09 domyka przeswit do kontraktu rodziny 3.
   - Sufit wisial 119-131 px nad glowa Leny (dol y=78-90, glowa ~209 przy
     stopach 296 i wzroscie 87) — 3-6x nad kontraktem 20-45 px
     (LOCATION_FAMILY_BIBLE §5). Opuszczona podbitka x 0..300 ze spodem
     y=172 (const RESIDENTIAL_CEILING_BOTTOM, LENA_HEAD_Y 209) daje
     przeswit 209-172 = 37 px.
   - Dwa plany (sufit + podbitka z listwa 166..172 i licem 296..300);
     drzwi 109 px nietkniete (Rect2 294,187,78,109 stoi); zero colliderow
     (kolider sufitu w .tscn zostaje 640x30 na y=15 — farba, nie fizyka).
   - OVERHEAD_FLOOR=86 dotyczy podwieszen w halach; tu wygrywa kontrakt
     niskiego sufitu mieszkalnej (precedens: sufit 10 do y=158), a etykieta
     MIESZKANIE 14 zeszla spod podbitki na sciane (322,100), dalej w pasie
     etykiet 90-190. Lampa do czytania wisi pod podbitka (glowa 230,184,
     stozek do stolu) jako jawne zrodlo dla kaluzy i cienia 0.48.
   - Sasiedzi tylko zaaudytowani: 08 masa do y=36 (otwarta klatka schodowa),
     10 masa do y=158 (near-miss 51 px, 6 px nad kontraktem), 13 pas sciany
     od y=42 bez podwieszonej masy. Ich sufity/palety naleza do osobnych
     pakietow (zakaz promptu).
2. Swiatlo (V6): 01 dostaje nazwane swiatlo rodziny 5.
   - 1 zrodlo robocze na beben: WORK_LIGHT_POS (247,188), ramie z korpusu
     maszyny, stozek HUMAN_AMBER 0.12 na stanowisko (istniejacy beben).
   - Zimne wypelnienie z gory: pas 18,44,604,26 ANCHOR_CYAN 0.06.
   - Jawny cien kontaktowy pod bebnem/pulpitem w prawo 0.48
     (CONTACT_SHADOW_ALPHA; zasieg x=312 poza obudowe 298, konwencja
     01/06/08); duzy cien maszyny (zasieg x=360) nietkniety.
   - Zadnych nowych baz koloru (AMBER/CYAN/INK juz w 01); linie 1.0 w 01
     nietkniete (poza zakresem V5, pinuje tylko 09).
   - Audyt 12/14: cienie kontaktowe 0.48 w prawo stoja (twarda obecnosc,
     read-only, bez przepisywania).
3. Roz (V10, decyzja D-232): regula akcentu Marty.
   - Marta w kadrze = wezel z character_id &"marta" w .tscn (strukturalnie,
     grepem; dzis 10 i 13) → 1 akcent → reszta w shade(MID_PLANE).
   - Roz (zgaszona czerwien, 2 odcienie, 1 slot, CAST §2.2) mieszka
     wylacznie na spricie/portrecie, nigdy w _draw stacji; stacje bez Marty
     do 2 akcentow (VISUAL_DESIGN §4); 09 bez Marty trzyma AMBER+CYAN bez
     oxide (re-pin V2).
   - Stan egzekucji: palety 10/13 nadal surowe hexy — regula wiaze ich
     przyszle przepisanie, nie dzisiejszy wyglad (osobny pakiet po 0219).
   - Mono 09 vs 01/11/12/15 rozni sie strukturalnie na 3 osiach rodziny
     (sylwetka: podbitka / hala maszyn / linia kontroli / szew;
     swiatlo: 2 niskie kaluze / robocze+wypelnienie / rowny gorny pas /
     warsztatowe / 1 niezgodne; material-czasownik: drzwi 109 / beben /
     lada / imadlo / nadajnik). Osie audio bez zmian.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0219_ceiling_light_rose_pin_test.gd` PASS (sufit
  09 37 px w 20-45 + drzwi/collidery/etykieta + audyt 08/10/13; 01
  work+fill+cien po stronie zrodla + audyt 12/14; D-232 + rigi Marty
  10/13 + akcenty 09 + markery 3 osi; fail-closed). PASS za pierwszym
  podejsciem, zero poprawek bramki.
- Pin `pkg_0207`: 113/112/111 po aktualizacji (regula D-222); 120. sekcja
  w `tools/verify.ps1`. Sasiedzi `pkg_0218/0217/0216/0165/0193/0194/0195/
  0168/0208/0137` PASS bez dotykania (w tym 0218: fartuch 22/22, 09 zero
  hex, zero 1.0 — kompozycja po podbitce nie zlamala palety ani linii).
- Zakresowa `tools/verify_scoped.ps1` PASS (docs + smoke 01-43 + 12 bramek;
  exit 0). Blast: 2 skrypty stacji (01: swiatlo; 09: sufit+lampa) + 1 scena
  (09: pozycja etykiety) + decyzja + testy + rejestracja bramki; zero
  shared-touch (zaden z plikow D-217 nie tkniety), zero enum/serialize/
  routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/
  postaci. Liczby D-221 nietkniete. Licznik D-217: 4. zakresowa po pelnej
  PKG-0215 (limit: pelna obowiazkowo w PKG-0220).
- Kadry: 21 PNG 640x360 (`reports/pkg_0219/visual/`, normalny sterownik
  Windows, Iris Xe, OpenGL) + `frames.tsv`: 01 i 09 x skale 85/100/115 x
  full/notext/mono (18) + mono 11/12/15 s100 (3). Inspekcja reczna HOLD
  obrazu, zero napraw: podbitka czyta sie masa nad wejsciem/sofa, lampa
  wisi pod nia ze stozkiem na stole, etykieta bez kolizji w full i gasnie
  w notext, skale trzymaja kompozycje; mono 09/11/12/15 rozroznialne
  ksztaltem i swiatlem (bursztyn/cyjan blisko lumy jak w 0218 — rozroznienie
  niosa sylwetka i pozycja zrodel, nie barwa). Baza "przed" to archiwa
  0187/0198/0203 (nie nadpisane).

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (przeswit 37 px, zrodlo +
wypelnienie + cien po stronie zrodla, regula D-232, markery 3 osi), nie
zabawy, emocji, zrozumienia ani odbioru (D-012, ADR-003). Oglad mono jest
oczny i strukturalny (obecnosc mas i zrodel), nie percepcyjny. Sufity
08/13 i near-miss 10 pozostaja otwarte; egzekucja reguly rozu w 10/13
czeka na ich przepisanie palet. Ekstrakcja tabel MRP (krok 2) nadal wymaga
oddzielnej dyspozycji (shared-touch -> pelna verify).
