# Programarea calculatoarelor și limbaje de programare 2 — Tema 3

Soluție realizată de Andrei-Marcel Bădulescu, Universitatea Politehnica București <br>
Dată — 22 mai 2025

### Prefață

<p> Soluția propusă respectă toate restricțiile și precizările privind coding
style-ul, mai exact includerea unor etichete care au un nume sugestiv,
indentarea corectă a codului (unde etichetele sunt așezate la margine, iar
codul este aliniat la un tab) și adăugarea unor comentarii care pot ajuta la
înțelegerea mai rapidă a codului. Toate funcțiile respectă standardul CDECL.
Acest README are scopul de a explica succint modul de rezolvare a celor patru
cerințe, cât și de a lămuri anumite decizii luate în decursul implementării
soluției prezentate. </p>

### Implementarea soluției
#### Cerința 1
<p> Pentru rezolvarea primei cerințe am căutat prima data nodul cu valoarea 1,
care îl salvez mai apoi pe stivă pentru a îl returna la final. După aceea, caut
nodul următor și mă folosesc de adresa nodului căutat anterior și o salvez în
memorie direct în spațiul special rezervat pentru fiecare element din array.
La final, returnez adresa primului nod salvată pe stivă. În cadrul rezolvării
nu sunt folosite funcții din biblioteca standard C, iar vectorul nu este
sortat. </p>

#### Cerința 2
<p> Pentru rezolvarea celei de-a doua cerințe, am folosit funcția Quicksort
din biblioteca standard C, iar funcția de comparare folosită de Quicksort
este implementată în NASM și mai apoi adresa ei de început este pusă pe stivă.
Funcția de comparare mai întâi verifică lungimea string-urilor date, iar dacă
acestea au la fel de multe caractere, atunci sunt comparate lexicografic.</p>

<p> Funcția care primește un string cu multiple cuvinte și le separă pe acestea
a fost implementată fără funcții externe din biblioteca standard C. Sunt căutate
caracterele non-alfanumerice, iar atunci când acestea sunt găsite, sunt înlocuite
cu valoarea 0 ('\0'). Pointerii către fiecare cuvând sunt reținuți în vectorul
a cărui adresă este transmisă ca parametru la întâlnirea primului caracter alfa-
numeric. </p>

#### Cerința 3
<p> În implementarea soluției pentru cerința 3 am optat pentru un algoritm
recursiv, astfel codul fiind mai concis și ușor de înțeles. Pentru fiecare
apel, este calculată limita inferioară, iar apoi sunt calculate recursiv
elementele sumei. Atunci când elementele cerute de funcția apelantă sunt
valori cunoscute, funcția identifică condițiile respectivă si returnează
automat valoarea predefinită. </p>

#### Cerința 4
<p> În implementarea soluției pentru cerința 4 au fost folosite funcțiile
calloc și free din biblioteca standard C (pentru a aloca memorie pe heap
pentru bufferul întors ca rezultat și cel utilizat pentru prelucrare). </p>

<p> Prima funcție (check_palindrome) verifică dacă un string este palindrom
sau nu cu ajutorul a doi pointeri, primul are adresa de început a bufferului
și al doilea are adresa ultimului byte al bufferului. Pe rând, este verificată
fiecare pereche de caractere până pointerele se întâlnesc sau primul devine
mai mare decât al doilea. </p>

<p> A doua funcție (composite_palindrome) concatenează în toate modurile
posibile cuvintele oferite cu ajutorul unor funcții ce imită comportamentul
omoloagelor din biblioteca standard C (strcmp, strcpy, strlen). Pentru procesul
recursiv de concatenare este folosită o funcție de backtracking, care verifică
fiecare combinație de cuvinte și dacă reprezintă un rezultat mai bun, îl
salvează în bufferul final, a cărui adresă este returnată la final. </p>

<b> Copyright 2025 © Andrei-Marcel Bădulescu. All rights reserved. </b>

