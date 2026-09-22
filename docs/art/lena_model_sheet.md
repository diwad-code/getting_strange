# Lena Wolska — Arkusz Modelu i Rig Wizualny (LenaVisualRig)

Status: **SPECYFIKACJA DOCELOWA; PROCEDURALNY SZKIELET PKG-0117 = ADAPT**  
Data: 2026-08-25  
Powiązane specyfikacje: `docs/LENA_CHARACTER_AND_ANIMATION.md`, `VISUAL_DESIGN.md`

Stan wdrożenia po PKG-0117: API stanów i oddzielenie od fizyki działają
technicznie, ale świeży capture pokazuje małą proceduralną figurę. Obecny rig
nie realizuje jeszcze opisanych niżej key poses, kontaktu stopy, opóźnienia
tułowia ani produkcyjnego aktorstwa. Poniższe wartości są kontraktem dla
PKG-0118, nie dowodem wykonania.

---

## 1. Tożsamość i cechy anatomiczne

- **Imię i nazwisko**: Lena Wolska
- **Wiek**: 36 lat
- **Zawód**: Inżynierka metrologii i pomiarów drgań infrastrukturalnych
- **Wzrost logiczny**: 48 px (zakres kanoniczny 44–52 px przed kompozytorem `320x180`)
- **Szerokość sylwetki**: 12–16 px w pozie spoczynkowej
- **Punkt ciężaru**: Stabilny, nisko osadzony w miednicy, odzwierciedlający dorosłą, sprawną fizycznie kobietę pracującą w terenie
- **Proporcje**:
  - Głowa: 8 px wysokości, krótki ciemny klin włosów (ink), linia wzroku/szczęka z ciepłym akcentem bursztynu (`HUMAN_AMBER`), dyskretna linia blizny przy zbliżeniu
  - Szyja i barki: 4 px, wyraźna linia ramion pod roboczą kurtką
  - Tułów / Kurtka: 16 px, techniczna kurtka terenowa (`MID_PLANE` / `LIGHT_PLANE`), asymetryczny pasek torby z czytnikiem
  - Rękaw lewy: Jasny szew serwisowy (`LIGHT_PLANE`), stanowiący kotwicę tożsamościową
  - Miednica i nogi: 20 px, techniczne spodnie ze wzmocnionymi kolanami (`DEEP_PLANE`), ciężkie buty robocze z wyraźną podeszwą (`INK`)

---

## 2. Paleta kolorystyczna (Tokeny Równi Pixel-Stage)

| Element | Token VectorStageStyle | Wartość heksadecymalna | Rola w sylwetce |
|---|---|---|---|
| Ciało / Twarz / Dłonie | `HUMAN_AMBER` | `#d6b66d` | Ciepły ludzki akcent, wzrok, kontakt z narzędziem |
| Włosy / Buty / Cień | `INK` | `#11161b` | Ostre krawędzie, masa, kontakt z podłożem |
| Kurtka terenowa (baza) | `MID_PLANE` | `#222d35` | Tkanina techniczna, masa tułowia |
| Kurtka (światło / szew) | `LIGHT_PLANE` | `#8fa4ad` | Światło górne, lewy szew rękawa, krawędź kołnierza |
| Spodnie robocze | `DEEP_PLANE` | `#172027` | Nogi, załamanie kolana, stabilność chodu |
| Torba narzędziowa | `HUMAN_AMBER` (akcent) / `DEEP_PLANE` | `#d6b66d` / `#172027` | Asymetria postaci, rekwizyt pomiarowy |
| Wskaźnik czytnika | `ANCHOR_CYAN` | `#58c4c6` | Aktywny obwód czujnika w dłoni |

---

## 3. Matryca dwunastu kluczowych stanów i póz

```
  [IDLE]         [WALK]         [RUN]          [JUMP RISE]    [LAND]         [UNEASE]
   ■■■            ■■■            ■■■            ■■■            ■■■            ■■■ (głowa wstecz)
  (o.o)          (o.o)>         (>.<)>         (^.^)          (o.o)          (o_O)
  /|▓|\          /|▓|/          //▓//          \|▓|/          /|▓|\          /|▓|\ (chwyt za torbę)
   |█|           / | \          / / \           |█|           /|█|\           |█|
  /   \         /   \          /     \         /   \         [===]           /   \ (stężona poza)
```

### 1. `idle` (Spoczynek)
- **Czas trwania**: Cykl oddechu 2.0 s (pętla)
- **Ciężar**: Oparty lekko na nodze wykrocznej, torba spoczywa przy prawym biodrze.
- **Ruch wtórny**: Subtelne unoszenie klatki piersiowej (1 px w szczycie), opadanie barków.

### 2. `start` (Przygotowanie ruchu)
- **Czas trwania**: 0.14 s
- **Ciężar**: Pochylenie tułowia w przód o 2.5 px, ugięcie kolana nogi przedniej przed przesunięciem collidera.

### 3. `walk` (Chód roboczy)
- **Kadencja**: 8–10 fps (długość kroku 24 px)
- **Fazy**:
  - Kontakt (heel strike): Noga wykroczna wyprostowana, pięta dotyka podłoża, torba lekko z tyłu.
  - Obniżenie (down): Amortyzacja ciężaru przez miednicę i kolano.
  - Mijanie (passing): Noga zakroczna mija pion tułowia, torba wraca do osi.
  - Wybicie (push-off): Noga tylna odpycha się od podłoża, lekkie uniesienie barków.

### 4. `run` (Bieg terenowy)
- **Kadencja**: 10–12 fps
- **Cechy**: Wyraźniejsze pochylenie tułowia (12 stopni), faza lotu trwająca 2 klatki, ramiona pracują w przeciwfazie do nóg.

### 5. `stop` (Hamowanie)
- **Czas trwania**: 0.18 s
- **Ciężar**: Cofnięcie bioder, stopa przednia blokuje ruch, ramiona stabilizują tułów.

### 6. `turn` (Zwrot / Zmiana kierunku)
- **Czas trwania**: 0.20 s
- **Cechy**: Posadzona stopa osiowa, obrót miednicy, tułów i barki kończą zwrot z opóźnieniem 1 klatki. Brak natychmiastowego przeskalowania -1x bez klatki pośredniej.

### 7. `jump_rise` (Wybicie i wznoszenie)
- **Wybicie**: 0.08 s ugięcia (bez opóźniania wejścia fizycznego), wyciągnięcie linii ciała ku górze, stopy podciągnięte pod tułów.

### 8. `jump_fall` (Opadanie)
- **Sylwetka**: Rozszerzone ramiona dla równowagi, stopy skierowane ku dołowi szukające kontaktu z podłożem.

### 9. `land` (Lądowanie)
- **Czas trwania**: 0.18 s (lekkie) do 0.30 s (ciężkie)
- **Amortyzacja**: Ugięcie kolan, opuszczenie tułowia o 4–6 px, torba narzędziowa opada z bezwładnością i wraca na miejsce.

### 10. `interact` (Interakcja / Obsługa aparatury)
- **Czas trwania**: 0.40–0.80 s
- **Geometria**: Prawa dłoń wyciągnięta na wysokość konsoli/bramki/klamki, głowa zwrócona ku punktowi interakcji.

### 11. `examine` (Badanie obiektu)
- **Postawa**: Lekki skłon w stronę badanego rekwizytu (rozdzielnicy, szyldu, gabloty), lewa dłoń podtrzymuje torbę, wzrok skupiony na detalu.

### 12. `unease_reaction` (Reakcja niepokoju)
- **Czas trwania**: 0.60–0.90 s
- **Cechy**: Zatrzymanie w pół kroku, odwrócenie głowy ku źródłu niezgodności, odruchowe sprawdzenie szwu na rękawie / mocniejszy chwyt paska torby.

---

## 4. Zasady niezależności mechanicznej

1. **Fizyka jest właścicielem pozycji**: `PrototypePlayer` (`CharacterBody2D`) decyduje o prędkościach, pozycjach, odbiciach i kolizjach.
2. **Animacja nie używa Root Motion**: Rig dopasowuje pozy i deformacje w lokalnym układzie współrzędnych.
3. **Deterministyczny Debug Override**: Metoda `debug_override_state(state_name)` pozwala na stabilne inspekcje wizualne i zrzuty ekranu bez wpływu na fizykę gry.
