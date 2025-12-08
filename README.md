# Napredna SQL Logika, Transakcije i Upravljanje Podacima

### Ukratko o projektu
Ovo je moj drugi projekt. Cilj je bio nadograditi osnovno modeliranje (iz prvog projekta) primjenom napredne poslovne logike i osiguravanjem integriteta podataka (Transakcije).

Ova skripta mi je pomogla da shvatim kako se SQL koristi za kompleksnu analizu i zaštitu unosa.

### Ključne vještine i što sam ovdje naučila:

* **Zaštita Podataka (Transakcije):**
    * Vježbala sam blokove koda **BEGIN/COMMIT/ROLLBACK** u kombinaciji s `IF EXISTS` provjerama.
    * Time sam osigurala da se podaci unose samo ako su svi uvjeti zadovoljeni (npr. 'Student postoji' i 'Predmet postoji').
* **Složeni Analitički Upiti:**
    * Koristila sam **Subqueries** (podupite) za izračunavanje prosjeka unutar drugih upita (npr. 'Pronađi studente čiji je prosjek veći od prosjeka svih studenata').
    * Rad s funkcijama prozora (`CASE` izrazi) za klasificiranje rezultata (npr. 'Položio' ili 'Nije položio').
* **Optimizacija i Reusable Code (Views i Varijable):**
    * Kreirala sam **VIEWs (Poglede)** za pojednostavljivanje čestih, složenih `JOIN` upita.
    * Koristila sam **Varijable (`DECLARE` i `SET`)** unutar SQL blokova za pohranu rezultata prosjeka, što je osnova za programiranje u bazama.
* **Proceduralno Programiranje:** Vježbala sam kreiranje jednostavnih **Stored Procedura**.

### Datoteke
* `2_Advanced_Logic_and_Transactions.sql`: Cijeli kod koji pokriva sve navedene vještine.

***
**Trenutni Cilj:** Tražim prvu priliku za neplaćenu praksu ili probni rad u području Data Analyst, s naglaskom na rad s MS SQL Serverom.
