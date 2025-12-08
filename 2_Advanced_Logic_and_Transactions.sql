----Ispiši ime studenta i naziv predmeta za svakog studenta koji je položio barem jedan predmet.

select Studenti.ime, Predmeti.naziv
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
inner join Predmeti on Ocjene.idPredmeta = Predmeti.idPredmeta
where ocjena is not null

----Pronaði za svaki smjer studija koliko studenata ima, ali samo one smjerove koji imaju više od 2 studenta. Sortiraj rezultat po broju studenata silazno.
select smjerStudija, count(*) as brStudenata
from Studenti
group by smjerStudija
having count(*)  > 2
order by brStudenata desc

----Pronaði sve smjerove studija gdje ima više od 3 studenta, i izraèunaj prosjeènu godinu roðenja za svaki od tih smjerova. Prikaži samo one smjerove kod kojih je prosjeèna godina roðenja studenata veæa od 1995.

select smjerStudija, avg(year(datRod)) as prosGodStudenta
from Studenti
group by smjerStudija
having count(*) > 3 and avg(year(datRod)) > 1995

----Izlistaj ime studenta i predmet na kojem je dobio ocjenu veæu od 4.
select Studenti.ime, Predmeti.naziv
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
inner join Predmeti on Predmeti.idPredmeta = Ocjene.idPredmeta
where ocjena > 4
----Napiši upit koji prikazuje prva 3 slova imena svih studenata.
select substring(ime, 1,3)
from Studenti
----Prikaži prva tri slova imena svih studenata, a ako je ime NULL, prikaži tekst 'nema'.
select substring(coalesce(ime, 'nema'), 1,3)
from Studenti 

----Prikaži ime studenta i dodatnu kolonu koja æe za ocjenu veæu od 4 pisati 'Položio', a za ocjenu 4 ili manju 'Nije položio'.
select Studenti.ime, Ocjene.ocjena, case	
										when ocjena > 4 then 'Položio'
										when ocjena = 4 then 'Nije položio'
										when ocjena < 4 then 'Nije položio'
										end ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa

----Prikaži za svaki smjer studija koliko ima studenata koji su “Položili” i koliko “Nisu položili” (prema ocjeni).
select smjerStudija, sum(case when ocjena > 4 then 1 else 0 end) as brojNepoloženih, sum(case when ocjena <= 4 then 1 else 0 end) as brPoloženih
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
group by smjerStudija

--Pronaði imena studenata koji su dobili najvišu ocjenu u tablici Ocjene.

select ime
from studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
where ocjena = (
		select max(ocjena)
		from Ocjene
		)

--Prikaži imena studenata koji su polagali bilo koji predmet koji predaje profesorica Ana Horvat.
select ime
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
inner join Predmeti on Ocjene.idPredmeta = Predmeti.idPredmeta
where Predmeti.idPredmeta in (
			select idPredmeta
			from Predmeti
			where imeProf = 'Ana Horvat'
			)

select * from Ocjene
select * from Predmeti

----Prikaži imena studenata koji su dobili ocjenu veæu od prosjeène ocjene svih studenata.
select ime
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
where Ocjene.ocjena > (
			select avg(ocjena) 
			from Ocjene
			)

----Prikaži imena studenata i njihove prosjeène ocjene, ali samo one studente koji imaju prosjek veæi od ukupnog prosjeka svih ocjena u tablici.

select ime, avg(ocjena) as ProsjecnaOcjenaStudenta
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
group by ime
having avg(ocjena) > ( select avg(ocjena)
					from Ocjene
						)


----Prikaži imena studenata koji imaju veæi broj položenih ispita (ocjena > 1) od prosjeènog broja položenih ispita svih studenata.

select ime, count(*)
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
group by ime
having count(*) > (select avg(Polozenih)
					from (select count(*) as Polozenih
								from Ocjene
								where ocjena > 1
								group by brIndeksa) as T
						)

----napravi view koji pokazuje studente i njihove prosjeène ocjene:
CREATE or alter VIEW ProsjekStudenata AS
SELECT Studenti.ime, AVG(Ocjene.ocjena) AS Prosjek
FROM Studenti
INNER JOIN Ocjene ON Studenti.brIndeksa = Ocjene.brIndeksa
GROUP BY Studenti.ime;

---napravi view koji prikazuje imena studenata, naziv predmeta i njihove ocjene
CREATE or alter VIEW StudentOcjenePredmeti AS
SELECT 
    s.ime,
    p.naziv,
    o.ocjena,
	p.imeProf
FROM 
    Studenti s
    INNER JOIN Ocjene o ON s.brIndeksa = o.brIndeksa
    INNER JOIN Predmeti p ON o.idPredmeta = p.idPredmeta;

---Koristi view StudentOcjenePredmeti i prikaži samo one studente koji su iz predmeta "Matematika" dobili ocjenu veæu od 3.

select ime
from StudentOcjenePredmeti
where naziv = 'Matematika' and ocjena > 3

--Prikaži imena studenata koji su položili barem jedan ispit kod profesora Marka Mariæa.
select ime
from StudentOcjenePredmeti 
where ocjena > 1 and imeProf = 'Marko Mariæ'

select * from Predmeti

--Prikaži imena studenata i nazive predmeta koje predaje profesor Marko Mariæ, a studenti su ih položili
select ime
from StudentOcjenePredmeti
where imeProf = 'Marko Mariæ' and ocjena > 1

--U SQL-u definiraj varijablu koja æe sadržavati prosjeènu ocjenu svih studenata iz tablice Ocjene. Zatim ispiši imena svih studenata èija je prosjeèna ocjena veæa od te varijable.

declare @prosjek float
set @prosjek = (select avg(ocjena) from Ocjene)
select ime
from Studenti s
inner join Ocjene o on s.brIndeksa = o.brIndeksa
group by ime
having avg(ocjena) > @prosjek

--broj svih položenih ocjena (veæih od 1), pa æemo onda izlistati samo one studente koji imaju više položenih ispita od prosjeka.
declare @prosjekPolozenih float;

-- 1. Varijabla dobiva prosjeèan broj položenih ispita po studentu
set @prosjekPolozenih = (
    select avg(Polozenih)
    from (
        select count(*) as Polozenih
        from Ocjene
        where ocjena > 1
        group by brIndeksa
    ) as T
);

-- 2. Glavni upit – izlistaj studente s više položenih od prosjeka
select s.ime, count(*) as BrojPolozenih
from Studenti s
inner join Ocjene o on s.brIndeksa = o.brIndeksa
where o.ocjena > 1
group by s.ime
having count(*) > @prosjekPolozenih;

--Postavi varijablu @prosjek_ocjena na prosjeènu ocjenu svih studenata.
--Prikaži imena studenata i njihove prosjeène ocjene koji imaju prosjek veæi od te vrijednosti.
declare @prosjek_ocjena float
set @prosjek_ocjena = (select avg(ProsjekPoStudentu)
						from(
							select avg(ocjena) as ProsjekPoStudentu
							from Ocjene
							group by brIndeksa
							) as T
							)
select ime
from StudentOcjenePredmeti
group by ime
having avg(ocjena) > @prosjek_ocjena

Select * from StudentOcjenePredmeti
select * from Predmeti

create trigger trg_ZabraniUpisAkoNijePolozenaMatematika
on Ocjene
instead of insert
as
begin
	if exists ( select 1 from inserted i
				where exists (
						select 1
						from Ocjene
						where brIndeksa = i.brIndeksa and idPredmeta = 2 and ocjena = 1)
			)
begin
	raiserror('Student nije položio Matematiku - nije moguæe unijeti novu ocjenu', 16, 1)
end
else
begin
	insert into Ocjene(brIndeksa, idPredmeta, ocjena)
	select brIndeksa, idPredmeta, ocjena
	from inserted
	end
end


SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;

------VJEŽBA PODUPITA NAKON PARCIJALNOG ISPITA------

--Ispiši sve predmete koje je polagao student s brojem indeksa 12345.

select distinct naziv
from Predmeti p
inner join Ocjene o on p.idPredmeta = o.idPredmeta
inner join Studenti s on o.brIndeksa = s.brIndeksa
where s.brIndeksa = 202308

select * 
from Ocjene



--Ispiši imena i prezimena svih studenata koji su položili ispit iz predmeta koji drži profesor èije ime je ‘Marko’.

select ime, prezime
from Studenti s
inner join Ocjene o on s.brIndeksa = o.brIndeksa
inner join Predmeti p on o.idPredmeta = p.idPredmeta
where o.ocjena is not null and p.idPredmeta in (select idPredmeta
												from Predmeti
												where imeProf = 'Marko')

--Napiši blok koda koji:
--Pokreæe transakciju
--Umeæe red u Ocjene za studenta 2023003, predmet 105, ocjenu 5, godina 2025
--Ako je ocjena manja od 2 ili veæa od 5, napravi ROLLBACK i ispiši poruku
--Inaèe napravi COMMIT i ispiši poruku da je transakcija uspješna

BEGIN TRANSACTION
DECLARE @ocjena INT = 5;
IF @ocjena < 2 OR @ocjena > 5
BEGIN
    ROLLBACK
    PRINT 'Dobio si nisku ocjenu za upis!';
END
ELSE
BEGIN
    INSERT INTO Ocjene (brIndeksa, idPredmeta, ocjena, godina_polaganja)
    VALUES (2023003, 105, @ocjena, 2025);

    COMMIT
    PRINT 'Transakcija uspješna';
END


--Napraviti transakciju koja:
--Provjerava postoji li student s indeksom 2023004 u tablici Studenti
--Ako postoji ? unese ocjenu za njega u tablicu Ocjene (npr. predmet 103, ocjena 4, godina 2025)
--Ako ne postoji ? napravi ROLLBACK i ispiše poruku: 'Student ne postoji – unos nije moguæ.'

BEGIN TRANSACTION

DECLARE @indeks INT = 2023004;
DECLARE @idPredmeta INT = 103;
DECLARE @ocjena INT = 4;
DECLARE @godina INT = 2025;

-- Provjera postoji li student
IF EXISTS (SELECT 1 FROM Studenti WHERE brIndeksa = @indeks)
BEGIN
    -- Provjera postoji li predmet
    IF NOT EXISTS (SELECT 1 FROM Predmeti WHERE idPredmeta = @idPredmeta)
    BEGIN
        ROLLBACK;
        PRINT 'Predmet ne postoji';
    END
    ELSE
    BEGIN
        -- Provjera postoji li veæ ocjena za tog studenta i predmet
        IF EXISTS (SELECT 1 FROM Ocjene WHERE brIndeksa = @indeks AND idPredmeta = @idPredmeta)
        BEGIN
            ROLLBACK;
            PRINT 'Ocjena veæ postoji';
        END
        ELSE
        BEGIN
            -- Upis nove ocjene
            INSERT INTO Ocjene (brIndeksa, idPredmeta, ocjena, godina_polaganja)
            VALUES (@indeks, @idPredmeta, @ocjena, @godina);

            COMMIT;
            PRINT 'Unos uspješan';
        END
    END
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Student ne postoji - unos nije moguæ';
END


--Napiši transakciju koja:
--Provjerava postoji li student s brojem indeksa (npr. 2023005)
--Provjerava postoji li predmet s idPredmeta = 102
--Provjerava je li student veæ polagao taj predmet (ako je, ne dopušta novi unos)
--Ako sve proðe, unosi ocjenu 5 za taj predmet i studenta, s godinom 2025
--Ispisuje poruku:
--'Ocjena uspješno unesena' ako sve proðe
--'Neuspješan unos – razlog: ...' ako nešto ne valja

begin transaction

declare @brIndeksa int = 2023002
declare @idPredmeta1 int = 102
declare @ocjena1 int = 5
declare @godina_polaganja int = 2025

if not exists (select 1 from Studenti where brIndeksa = @brIndeksa)
    begin
    rollback
    print 'Student ne postoji'
    return
    end

 else


begin
if not exists (select 1 from Predmeti where idPredmeta = @idPredmeta1)
        begin
        rollback
        print 'Predmet ne postoji'
        return
        end

else
   
begin
if exists (select 1 from Ocjene where brIndeksa=@brIndeksa and idPredmeta = @idPredmeta1 and ocjena is not null)
    begin
        rollback
        print 'Student je veæ polagao taj ispit'
    return
    end
else

begin
    insert Ocjene
    values(@ocjena1, @godina_polaganja,@brIndeksa, @idPredmeta1)
    commit
    print 'Ocjena uspješno unesena'
end
end
end


--primjer jednostavne procedure
CREATE OR ALTER PROCEDURE PozdraviKorisnika
    @ime NVARCHAR(50)
AS
BEGIN
    PRINT 'Pozdrav, ' + @ime + '!'
END


---kako pozvati proceduru
exec PozdraviKorisnika @ime = 'Mia'
