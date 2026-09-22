# Biblia rodzin lokacji P9

Status: **AKTYWNY KONTRAKT PRODUKTU P9 — BUNDLE-04 / PKG-0156**
Data: 2026-08-31
Decyzje nadrzędne: D-168, ADR-008
Kanon obrazu: `VISUAL_DESIGN.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`
Kanon skali: `docs/WORLD_SCALE.md` (1 m = 52 px, Lena 87 px, kadr 640×360)
Kanon przeszkód: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`

Wiążący fakt właściciela: **lokacje wyglądają zbyt podobnie, a rodziny
przestrzeni są wizualnie nierozróżnialne.** Przyczyna jest znana z runtime:
23 sceny 19–41 dzielą jeden layout `Geometry` (podłoga 640×80, ściany x=-10
i x=650), jeden zestaw `Props` (4–5 `Area2D` z `memory_resonance_point.gd`)
i jednego autora wyglądu (`VectorStageEnvironment`). Ten dokument to rozwiązuje.

---

## 1. Zasada nadrzędna

> **Rodzinę rozpoznaje się po sylwetce i po tym, co w niej działa —
> nigdy po kolorze i nigdy po napisie.**

Test rozstrzygający dla każdej przestrzeni:

1. wyłącz cały tekst;
2. zredukuj kadr do monochromu;
3. pokaż jedną klatkę.

Jeżeli nie da się wtedy powiedzieć, do której z siedmiu rodzin należy kadr —
przestrzeń jest wadliwa i nie wchodzi do kampanii.

## 2. Pięć osi różnicowania

Każda rodzina ma własny profil na pięciu osiach. **Dwie dowolne rodziny muszą
różnić się na co najmniej trzech z pięciu osi.**

| Oś | Co określa |
|---|---|
| sylwetka | dominujący kierunek linii i obecność/brak sufitu i nieba |
| materiał | ziarno, krawędź, rytm powtarzalnego modułu |
| światło | liczba źródeł, ich wysokość i kierunek cienia |
| audio | źródło dźwięku w kadrze, długość i twardość pogłosu |
| czasownik | dominujące działanie gracza |

---

## 3. Rodzina 1 — zewnętrzna / miejska

**Adresy:** 02, 05, 06, 07, 18.

| Oś | Kontrakt |
|---|---|
| sylwetka | otwarte niebo zajmuje ≥ 25% wysokości kadru; brak sufitu; minimum trzy plany głębi; dominują pionowe podziały fasad |
| materiał | tynk, cegła, beton chodnikowy, blacha, szkło witryn; okna jako rytm co 26–34 px; krawężnik 8–12 px (próg bez skoku) |
| światło | jedno źródło wysoko (latarnia 200–230 px) z długim cieniem + jedno na poziomie chodnika (witryna, okno) |
| audio | dalszy ruch uliczny jako tło, punktowe źródła w kadrze (wentylator, radio), pogłos otwarty i krótki |
| czasownik | orientacja i porównanie trasy |

**Zakazane powtórzenie:** laboratoryjne proscenium, symetryczna ściana bez
okien, sufit nad głową, plansza bez horyzontu.

**Test mono:** widać niebo i co najmniej trzy plany; nie widać sufitu.

## 4. Rodzina 2 — przystanki / tranzyt

**Adresy:** 03, 04.

| Oś | Kontrakt |
|---|---|
| sylwetka | pozioma krawędź peronu albo toru dzieli kadr; zadaszenie **częściowe**; we wnętrzu pojazdu korytarz z rytmem okien |
| materiał | stal ocynkowana, guma, tworzywo siedzisk, szkło rozkładu, malowane pasy ostrzegawcze czytelne jako pasy, nie jako kolor |
| światło | świetlówka pod wiatą; światło pojazdu przesuwające się poziomo przez kadr |
| audio | komunikat rozkładu, stukot toru, pneumatyczne drzwi; rytm odjazdu obserwowalny **przed** próbą (R5) |
| czasownik | oczekiwanie, wejście, wybór kierunku |

**Zakazane powtórzenie:** rząd terminali, nieruchome tło bez pojazdu,
zadaszenie pełne jak w hali.

**Test mono:** widać krawędź toru lub peronu oraz częściowe zadaszenie.

## 5. Rodzina 3 — mieszkalne

**Adresy:** 08, 09, 10, 13.

| Oś | Kontrakt |
|---|---|
| sylwetka | **niski sufit**: prześwit nad głową Leny 20–45 px; maksymalnie dwa plany głębi; drzwi 109 px jako główny podział |
| materiał | tkanina, drewno, ceramika, tapeta, dywan; krawędzie miękkie; ślady dwóch osób w każdym kadrze |
| światło | 2–3 małe źródła na wysokości 47–150 px (lampka, kuchnia, ekran); brak jednego zimnego światła górnego |
| audio | lodówka, rura, sąsiad zza ściany; pogłos krótki i tłumiony tkaniną |
| czasownik | ostrożne badanie i granica prywatności |

**Zakazane powtórzenie:** instytucjonalne etykiety i pulpity, symetryczne rzędy
mebli, przestrzeń wyższa niż dwie wysokości Leny.

**Test mono:** sufit jest w kadrze, a w przestrzeni widać dwa komplety rzeczy
codziennych.

## 6. Rodzina 4 — instytucjonalne

**Adresy:** 11, 17.

| Oś | Kontrakt |
|---|---|
| sylwetka | długa oś w głąb; jawna linia kontroli (lada, bramka, kołowrót) na wysokości 100–110 px; moduł powtarzalny co 64 px |
| materiał | szkło, laminat, malowany metal, wykładzina; krawędzie twarde i równoległe |
| światło | równomierne górne, cienie płytkie, zero ciepłego punktu |
| audio | stała wentylacja, przewijana lista, sygnał bramki; echo płaskie i długie |
| czasownik | autoryzacja, porównanie, odmowa |

**Zakazane powtórzenie:** domowe ciepło jako dekoracja, przytulny mebel,
pojedyncza lampka jako główne źródło.

**Test mono:** widoczna linia kontroli i powtarzalny moduł ciągnący się w głąb.

## 7. Rodzina 5 — techniczne / przemysłowe

**Adresy:** 01, 12, 14.

| Oś | Kontrakt |
|---|---|
| sylwetka | maszyna o czytelnej funkcji zajmuje ≥ 1/3 szerokości kadru; rury i kanały prowadzą wzrok po diagonali; poziomy robocze łączy drabina albo winda |
| materiał | stal, farba antykorozyjna, kabel, izolacja, olej; nity i śruby jako drobny rytm |
| światło | światło robocze skierowane na stanowisko + zimne wypełnienie z góry; pod maszyną cień głęboki |
| audio | cykl maszyny słyszalny i obserwowalny przed próbą, sprężone powietrze, metal; pogłos twardy |
| czasownik | czytanie cyklu i fizyczna praca |

**Zakazane powtórzenie:** konsola bez funkcji, ekran zastępujący zdarzenie,
gładka ściana bez instalacji, maszyna, która zatrzymuje się i czeka na gracza.

**Test mono:** widać maszynę z ruchomą częścią, która wykonuje swoją pracę.

## 8. Rodzina 6 — graniczne / anomalne

**Adresy:** 15, 16.

Ta rodzina **nie ma własnego stylu**. Jest znaną rodziną ze złamanym dokładnie
jednym parametrem.

| Oś | Kontrakt |
|---|---|
| sylwetka | topologia rodziny bazowej (techniczna dla 15, mieszkalna albo techniczna dla 16) z jedną niezgodnością geometryczną: ten sam element istnieje w dwóch wersjach |
| materiał | identyczny jak w rodzinie bazowej; różnicę niesie **stan** tej samej powierzchni, nie nowy materiał |
| światło | dokładnie jedno źródło zachowuje się niezgodnie z resztą kadru (kierunek cienia albo opóźnienie) |
| audio | dokładnie jeden dźwięk bez źródła w kadrze; nic więcej |
| czasownik | Anchor/Yield i porównanie dwóch stanów |

**Zakazane powtórzenie:** globalny glitch, aberracja całego ekranu, druga
anomalia w tej samej scenie, „kosmiczna” przestrzeń bez odniesienia.

**Test mono:** obserwator wskazuje palcem **jeden** element, który nie zgadza
się z resztą kadru.

## 9. Rodzina 7 — finałowe / epilogiczne

**Adresy:** 42A, 42B, 42C, 43.

| Oś | Kontrakt |
|---|---|
| sylwetka | przestrzeń już odwiedzona; ta sama bryła, zmieniony jeden fakt dotyczący osób (puste krzesło, otwarte drzwi, zajęty tor) |
| materiał | zero nowych materiałów; wyłącznie te z rodzin 1–6 |
| światło | ta sama armatura, inna pora (świt); zmiana wynika z godziny, nie z symboliki |
| audio | cisza z jednym źródłem; brak muzycznego triumfu i brak stingu |
| czasownik | odczyt skutku i jedna ostatnia czynność |

**Zakazane powtórzenie:** moralny kolor zakończenia, manifest lub monolog jako
epilog, nowa lokacja pojawiająca się dopiero w finale.

**Test mono:** obserwator rozpoznaje miejsce z wcześniejszego adresu i wskazuje,
co się w nim zmieniło.

---

## 10. Macierz różnicowania

| Rodzina | Sylwetka | Materiał | Światło | Audio | Czasownik |
|---|---|---|---|---|---|
| miejska | niebo, piony fasad | tynk / szkło witryn | wysokie + witryna | otwarty, krótki pogłos | orientacja |
| tranzytowa | pozioma krawędź, dach częściowy | stal / guma / tworzywo | świetlówka + światło przejeżdżające | rytm odjazdu | oczekiwanie i wejście |
| mieszkalna | niski sufit, ciasny plan | tkanina / drewno / ceramika | 2–3 małe, niskie | tłumiony, bliski | ostrożne badanie |
| instytucjonalna | oś w głąb, linia kontroli | szkło / laminat / metal | równomierne górne | płaskie, długie echo | autoryzacja |
| techniczna | masa maszyny, diagonale rur | stal / kabel / olej | robocze + zimne wypełnienie | cykl maszyny | praca fizyczna |
| graniczna | duplikat elementu bazowego | jak baza, dwa stany | jedno źródło niezgodne | jeden dźwięk bez źródła | Anchor / Yield |
| finałowa | znana bryła, jedna zmiana | bez nowych | ta sama armatura, świt | cisza z jednym źródłem | odczyt skutku |

Kontrola: każda para wierszy różni się na co najmniej trzech kolumnach.

## 11. Zakazy wspólne

1. Jeden layout `Geometry` dla wielu rodzin jest zabroniony; podłoga 640×80
   i ściany x=-10 / x=650 przestają być domyślnym szkieletem.
2. `VectorStageEnvironment` nie jest autorem wyglądu nowych rodzin (R-042).
3. `MemoryResonancePoint` nie jest domyślnym modelem każdej interakcji;
   maksymalnie trzy istotne interakcje na adres.
4. Rodzina nie może być komunikowana etykietą diegetyczną ani promptem.
5. Ta sama rodzina nie może wystąpić w więcej niż trzech kolejnych adresach.
6. Zmiana rodziny musi być widoczna w pierwszej klatce po przejściu progu.

## 12. Rytm rodzin na trasie

| Adresy | Rodziny | Kontrola |
|---|---|---|
| 01 → 04 | techniczna → miejska → tranzytowa → tranzytowa | trzy rodziny w pierwszych pięciu minutach |
| 05 → 08 | miejska → miejska → miejska → mieszkalna | maksymalnie trzy z rzędu, potem zmiana |
| 09 → 13 | mieszkalna → mieszkalna → instytucjonalna → techniczna → mieszkalna | powrót do znanej rodziny po zmianie |
| 14 → 18 | techniczna → graniczna → graniczna → instytucjonalna → miejska | finał otwarcia wraca na ulicę z 05 |
| 42A/B/C → 43 | finałowa → finałowa | wyłącznie miejsca już odwiedzone |

Liczba adresów per rodzina: miejska 5, mieszkalna 4, techniczna 3,
tranzytowa 2, instytucjonalna 2, graniczna 2, finałowa 2 (w tym trzy warianty
sceniczne 42). Suma: 20 adresów.

## 13. Dowód wymagany przez BUNDLE-04

Siedem monochromatycznych blockoutów — po jednym na rodzinę, bez tekstu, bez
UI, w kadrze 640×360, renderowanych normalnym sterownikiem Windows. Blockout
jest zaliczony, gdy spełnia własny „test mono” z rozdziałów 3–9 oraz macierz
z rozdziału 10.

Blockouty powstają w PHASE-02 razem z pierwszymi adresami. PKG-0156 ustanawia
wyłącznie kontrakt; nie renderuje jeszcze obrazu i nie zmienia runtime.

## 14. Czego ta biblia nie dowodzi

Dokument i render dowodzą rozróżnialności strukturalnej. Nie dowodzą urody,
nastroju ani tego, że gracz poczuje różnicę miejsc (D-012, ADR-003).
