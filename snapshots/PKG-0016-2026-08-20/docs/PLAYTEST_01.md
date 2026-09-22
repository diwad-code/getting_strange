# Protokol playtestu 01

## Warunki

- 5 osob, ktore nie widzialy wczesniej prototypu;
- nagrywanie ekranu i czasu po uzyskaniu zgody;
- jedna osoba na raz, bez komentarza prowadzacego;
- kazda osoba przechodzi profile A, B i C na tej samej geometrii;
- tester nie widzi kodu, konsoli, dokumentacji profili ani kolejnosci;
- jedna osoba uzywa tego samego urzadzenia wejscia we wszystkich trzech
  profilach, aby nie mieszac efektu profilu z nauka klawiatury lub pada;
- przy pieciu osobach uzyc kolejnosci `ABC`, `BCA`, `CAB`, `ACB`, `BAC`;
- kazdy profil startuje w nowym procesie przez
  `tools/run_movement_profile.ps1`, z pozycja i predkoscia poczatkowa;
- facylitator zapisuje przypisanie osoby, kolejnosc, urzadzenie i kod profilu
  w notatkach niedostepnych testerowi.

Trzy osoby powinny uzyc klawiatury, a dwie pada, o ile dostepnosc lub potrzeby
testera nie wymagaja inaczej. Odstepstwo nalezy zapisac; nie zmieniac urzadzenia
w polowie porownania.

## Instrukcja dla testera

"Zagraj tak, jakby byl to poczatek nieznanej gry. Mysl na glos tylko wtedy,
gdy masz na to ochote. Nie bede pomagal, ale po probie odpowiem na pytania."

## Obserwacje podczas gry

Kazdy wiersz zapisujemy osobno dla A, B i C. Miary pierwszego odkrycia
sterowania sa miarodajne tylko dla pierwszego profilu danej osoby; przy
pozostalych profilach istnieje efekt uczenia.

| Pomiar | Zapis |
|---|---|
| Czas do pierwszego ruchu | sekundy |
| Czas do pierwszego skoku | sekundy |
| Czas pierwszego przejscia | sekundy lub brak |
| Liczba upadkow | liczba |
| Nieudane wejscia niewykonane przez gre | opis i znacznik czasu |
| Miejsca zawahania powyzej 3 sekund | pozycja i komentarz |
| Czy gracz odkryl krotki skok | tak/nie, ktora proba |
| Czy uzyl restartu samodzielnie | tak/nie |

Po kazdym profilu, bez porownywania go z nazwana alternatywa, zapisac jedno
zdanie: co bylo przewidywalne i co zaskoczylo. Po wszystkich trzech profilach
tester szereguje je od najbardziej do najmniej preferowanego oraz podaje
powod pierwszego wyboru.

## Pytania po probie

1. W ktorym momencie sterowanie zrobilo cos innego, niz oczekiwales?
2. Czy postac wydawala sie ciezka, ospala, precyzyjna czy nerwowa? Dlaczego?
3. Czy przed skokiem potrafiles przewidziec miejsce ladowania?
4. Ktora porazka byla twoim bledem, a ktora bledem gry?
5. Czy chcialbys przejsc jeszcze jeden, trudniejszy kadr?

## Interpretacja

Preferencja testera nie jest sama w sobie dowodem. Najpierw analizujemy
zachowanie i powtarzalne problemy, potem wypowiedzi. Nie stroimy gry pod jedna
osobe i nie testujemy ponownie na tych samych osobach po istotnej zmianie.

Profil spelnia porownawcze kryterium T4 tylko wtedy, gdy wskaza go co najmniej
3 z 5 osob i zapisane powody nie sa sprzeczne z obserwowanym zachowaniem.
Niezaleznie od preferencji nadal obowiazuja wszystkie bramki P1. Przy remisie
lub rozbieznych danych decyzja brzmi `ITERATE` albo "potrzeba wiecej danych",
nie sztuczny wybor zwyciezcy.
