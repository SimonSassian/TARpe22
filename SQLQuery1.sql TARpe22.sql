-- komm
-- teeb andmebaasi ehk db
create database TARpe22

-- kustutamine db
drop database TARpe22

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'male')
insert into Gender (Id, Gender)
values (1, 'female')
insert into Gender (Id, Gender)
values (3, 'unknown')

-- sama Id v"rtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
Id int not null primary key,
name nvarchar(30),
Email nvarchar(30),
GenderId int
)

---vaatame Person tabeli sisu
select * from person

---andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'wonderwoman', 'w@w.com.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Antman', 'ant@ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from person

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(id)

---kui sisestad uue rea andmeid ja ei ole sisestanud GenderId all v''rtuse
---see automaatselt sisestab tabelisse v''rtuse 3 ja selleks on unknwon
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email)
values (9, 'Ironman', 'i@i.com')

select * from Person

-- piirangu maha v]tmine
alter table Person
drop constraint DF_Persons_GenderId

---lisame uue veeru
alter table Person
add age nvarchar(10)

--- lisame vanus piirangu sisestamisel
--- ei saa lisada suuremat v''rtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale id, siis ei muuda midagi
delete from Person where Id = 10

select * from Person

--kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothami linnas
select * from Person where City !='Gotham'
-- teine variant
select * from Person where not City = 'Gotham'
-- kolmas variant
select * from Person where City <> 'Gotham'

-- n�itab teatud vanusevahemikus olevad inimesi
select * from Person Age between 20 and 35

-- wildcard e n�itab k�iki g-t�hega linnad
select * from Person City like 'g%'
--n�itab k�ik emailid, milles on @ m�rk
select * from Person Email like '%@%'

--- n�itab k�iki kellel ei ole @-m�rki emailis
select * from Person where Email no like '%@%'

--- n�itab, kellel on emailis ees ja peale @-m�rk
-- ainult �ks t�ht
select * Person where Email like '_@_.com'

--k�ik kellel ei ole nimes esimene t�ht W, A, C
select * Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k�ik kes elavad Gothamis ja New Yorkis ning
-- �le 30 eluaastast
select * from Person where
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t�hestulikses j�rjekorras inimesi
--- ja v�tab aluseks nime

select * from Person order by Name
-- kuvab vastaspidises j�rjekorras
select * from Person order by Name desc

-- v�tab kolm esimest rid
select top 3 * from Person

--- 2 tund
