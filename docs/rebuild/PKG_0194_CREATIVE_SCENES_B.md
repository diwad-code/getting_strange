# PKG-0194 / CR-B — Raport: odpowiedź, koszt i cudza zgoda (14–18)

Data: 2026-09-05. Pakiet wykonawczy CR-B z
`docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §7 (kolejka CR-A →
**CR-B** → CR-C → CR-D, kontrakt §8.1). Nie jest PRODUCT GO ani decyzją
wydawniczą (D-168 blokuje release i nowy `.exe`).

## Co dostarczono (rozmowy, nie fakty)

Trasa i fizyka bez zmian: 20 adresów, progi, InputMap, 60 Hz, 640×360, zero
nowych colliderów, ≤3 istotne interakcje na adres. Nowi writerzy faktów nie
powstali; wszystkie zapisy robią dotychczasowe czasowniki stacji.

- **14 (martwy obwód):** dziennik podstacji pokazuje widoczną zmianę sekcji
  przed roboczym nazwaniem; po obu zachowaniach reread dostarcza nazwanie
   („Zakotwiczenie i uległość”). Oba zachowania mechaniczne zachowane.
- **15 (wzajemny sygnał):** log 20:40 rozdziela zamiar miejscowej Leny od
  późniejszej interwencji UCP i ustanawia przyczynowość CR-D §2 (pierwszy
  obowiązkowy odczyt = kontakt na obu gałęziach; powtórka = pełna próbka i
  opóźniony powrót). Trzeci impuls wymaga jawnego uzbrojenia w tym samym
  nadajniku (`arm_deliberate_error_pattern()`, bez faktu); odpowiedź wraca
  po ~1,4 s i dopiero wtedy kolejkuje rozmowę. Notatka: abort po braku
  odpowiedzi, bez uprzedniej zgody.
- **16 (mały koszt):** po transferze odpowiedzi kolejka dokłada podgląd obu
  alternatyw; wybór (strona gracza) dostarcza jeden konkretny ubytek:
  urwane zdanie Marty na łączu (gałąź pamięci, detal kurtki z 10) albo
  rozmytą sekundę 20:40:07 (gałąź próbki; bez surowej próbki nośnik to bufor
  czytnika, nigdy „pełna próbka”). Echo domu: wiadomość domowej Marty
  o zaginięciu + przesłanka przeciw prostej podmianie.
- **17 (rachunek Linii 4):** trzy akty — para zdarzeń z datą i dwiema
  stronami (bez utożsamiania korelacji z dowodem winy osobowej), oferta
  adaptacji Wierzbickiej z odmową, prośba Leny + odpowiedź Jakuba jawnie
  zależna od zakresu. `limited` dostał równą dramaturgię (koniec asymetrii
  E11); dialog zgody przeniesiony ze stacji do kolejki prezentera. Codzienny
  cel Jakuba z 12 („oddać napęd przed końcem zmiany”) wraca we wszystkich
  trzech zakresach.
- **18 (prognozy i prawda):** tablica pokazuje chronioną wartość, znaną
  stratę, niewiadomą i faktyczne braki — zależnie od zakresu zgody (przy
  `refused` wszystkie trzy drogi nazywają lukę, nie fabrykują zgody).
  Prawda Marty: pełna / częściowa / wstrzymana, każda z konkretną treścią
  i granicą. Post zatwierdzenia: ruch Leny jako jej prośba, nie wola Jakuba.

## Zmiany kodu

- `scripts/levels/creative_scene_lines.gd` — treść CR-B + `lines_for(...,
  station)` z gałęziami faz (15), wyboru (16), zakresu (17/18), prawdy
  i metody (18) oraz bramką wiedzy `world_recognized` dla 17/18 (D-211).
  Pomocnik `_truthy()` zamiast konstruktora `bool()` (Godot 4.7 nie ma
  konwersji String → bool; wykryte twardym błędem w tym pakiecie).
- `scripts/levels/creative_scene_presentation.gd` — straż winiety dla
  każdego `CinematicVignette_*` (vig_signal na 15, vig_commit na 18),
  podgląd alternatyw kosztu po analizatorze, pomijanie kolejkowania przy
  oczekującym echu 15, fazy nadajnika dla niezakończonych punktów.
- Stacje 14–18: wyłącznie podpięcie prezentera w `_ready()` (3 linie, wzór
  CR-A). Plus: 15 jawne uzbrojenie błędnego wzoru na ścieżce MRP
  (bezpośrednie wołania bez zmian — bramka 0163 nietknięta); 17 cisza
  bezpośredniego CRT na rzecz kolejki (fakty bez zmian).
- `scripts/core/game_state_manager.gd` — D-211: `mechanic_cost_observed`,
  `local_lena_intent_found`, `home_echo_verified`, `ucp_cost_ledger_found`
  kończą erasure migracyjną (stali writerzy P9 w 15/16/17; trasa P9 nigdy
  nie stempluje rewizji P7, więc każdy reload je kasował i łamał bramkę
  donora 17 — ten sam defekt co D-208, warstwę głębiej; wykryty bramką
  save/reload tego pakietu).
- `tests/pkg_0145_smoke_test.gd:166` — jak w PKG-0191: asercja kasowania
  zamieniona na przetrwanie z komentarzem (fakt kanoniczny, nie skażenie).
- `tests/pkg_0194_creative_scene_b_test.gd` — nowa bramka + wpis w
  `tools/verify.ps1`. `tests/pkg_0165_smoke_test.gd` nietknięty (lint stoi).

## Konflikt 0165 (nazwany wprost, nie „kosmetyka testów”)

Stara asercja `pkg_0165:231–234` zabrania w `station_17.gd` pojęć, które po
rozpoznaniu w 13 są legalnym tematem 17 (mapa P9). Kontrola zastępcza,
równoważna lub silniejsza: (a) `station_17.gd` nadal nie zawiera żadnego
z terminów (cała treść 17 żyje w `creative_scene_lines.gd`, poza zasięgiem
linta — lint GREEN bez zmian pliku); (b) nowa kontrola dynamiczna obejmuje
faktycznie prezentowany tekst i stan wiedzy: treść 17/18 schodzi na
knowledge-fallback przed `world_recognized`, treść pełna dopiero po.
Test dowodzi obu stron: fallback bez „Równi” przed rozpoznaniem, para
zdarzeń po rereadzie z rozpoznaniem. Decyzja D-211.

## Weryfikacja

- `tests/pkg_0194_creative_scene_b_test.gd` — **PASS**: trzy pełne trasy
  (próbka+pamięć+granted+full+force_home→42A; próbka+sekunda+limited+
  partial+close_equal→42B; bez próbki+bufor+refused+withheld+mutual→42C),
  kolejność warstw na złączeniach, braki źródeł, bramka wiedzy, save/reload
  przed/po zatwierdzeniu, powrót (ReturnZone + ThresholdBinder na 17),
  6 winiet (vig_signal + vig_commit na trasę, skip semantyczny), skale
  85/100/115% z kontrolą wysokości tekstu.
- Sąsiedzi GREEN: 0162/0163/0164/0165/0166, 0145, 0147/0148/0151,
  0190/0191/0193. Baseline `verify.ps1` startował przed edycjami i złapał
  stan pośredni pliku (błąd kompilacji naprawiony w pakiecie); wiążący jest
  końcowy pełny przebieg (niżej) — jak w CR-A (run1/run2).
- Kadry Windows (normalny sterownik, ten sam harness): 309 PNG +
  `reports/pkg_0194/visual_final/frames.tsv`. Obejrzane: koszt Marty (16),
  para rejestru (17), prognozy i zatwierdzenie (18) — ostre dialogi ponad
  pikselizacją, tekst mieści się w panelu.

## Granice (czego nie dowodzi)

Jak CR-A: brak dowodu odbioru (D-012 — zero zewnętrznych testerów, nigdy),
czasu człowieka, komfortu sterowania ani miksu. Testy dowodzą dostarczenia
treści i kontraktów, nie wzruszenia.

## Następny pakiet

CR-C (finały 39–43 + nośniki stanów osób + epilog/credits), specyfikacja
w planie §7. Numer spodziewany: PKG-0195.
