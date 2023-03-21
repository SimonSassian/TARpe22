- komm
-- teeb andmebaasi ehk db
create database TARpe22_4

-- kustutamine db
drop database TARpe22_3

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

--võõrvõtme ühenduse loomine kahe tabeli vahel
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

-- n'itab teatud vanusega inimesi
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- n'itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
-- n'itab, k]ik emailid, milles on @ märk
select * from Person where Email like '%@%'

--- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--- n'itab, kellel on Emailis ees ja peale @-märki
-- ainult üks täht
select * from Person where Email like '_@_.com'

-- k]ik, kellel ei ole nimes esimene t'ht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning
-- alla 30 eluaastat
select * from Person where
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t'hestikulises järjekorras inimesi
--- ja võtab aluseks nime

select * from Person order by Name
-- kuvab vastupidises järjekorras
select * from Person order by name desc

-- võtab kolm esimest rida
select top 3 * from Person

--- muudab age muutuja int-ks ja näitab vanuselises järiestuses
select * from Person order by cast(Age as int)

--- kõikide isikute koondvanus
select SUM(CAST(Age as int))from Person

--- näitab, kõige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- näitab, kõige nooremat isikut
select MIN(CAST(Age as int)) from Person

-- näeme konkreetsetes linnades olevate isikute koondvanust
-- enne oli age string, aga päringu ajal muutsime selle int-ks
select City, SUM(CAST(Age as int)) as TotalAge from Person groub by City

--kuidas saab koodiga muuta tabeli andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int

select City, GenderId, SUM(Age) as TotalAge from Person
groub by City, GenderId order by City

---näitab, et mitu rida on selles tabelis
select COUNT(*) from Person
select * from Person

--- veergude lugemine
select COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='Person'

---
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
where GenderId = '2'
group by GenderId, City

--- n'itab, et mitu inimest on vanemad, kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

--loome uue tabelid
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
[location] nvarchar(50)
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50)
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)


insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(1,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(2,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(3,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(4,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(5,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(6,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(7,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(8,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(9,'TOM','MALE',4000,1)
insert into Employees(Id, Name Gender, Salary, DepartmentId)
values(10,'TOM','MALE',4000,1)


insert into Department)Id, DepartmentName, Location, DepartmentHead)
values
(1, 'IT'. 'London', 'Rick')
(2, 'Payroll', 'Delhi', 'Ron')
(3, 'Hr', 'New York', 'Cristie')
(4, 'Other Department', 'Sydney', 'Cinderella')


select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

---arvutame [he kuu palgafondi
select SUM(CAST(Salary as int)) from Employees
--- min palga saaja ja kui tahame max palga saajat,
--- siis min asemel max
select MIN(CAST(Salary as int)) from Employees
-- ühe kuu palgafond linnade l]ikes

---lisame veeru niimega City
alter table Employees
add City nvarchar(30)

select * from Employees

select City, SUM(CAST(Salary as int)) as TotalSalary
from Employess
group by City

--linnad tähestikues järjestuses
select City, SUM(CAST(Salary as int)) as TotalSalary
from Employess
group by City, Gender
order by City

--- loeb ära mitu inimest on nimekirjas
select COUNT(*) from Employees

--- vaatame mitu töötajat on soo ja linna kaupa
select Gender, City, SUM(CAST)Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employees(s)]
from Employees
group by Gender, City

--näidata kõiki mehi linnade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employees(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--- näitab ainult kõik naised linade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employees(s)]
from Employees
group by Gender, City
having Gender = 'Female'

---vigane päring 
select * from Employees where SUM(CAST(Salary as int)) > 4000

-- töötav varjant
select Gender, City, SUM(CAST(Salary as int)) as [Total Salary],
COUNT (Id) as [Total Employees(s)]
from Employees group by Gender, City
having SUM(CAST(Salary as int)) > 4000

--- loome tabeli, milles tahetakse auomaaltselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values ('X')

select * from Test1

--- inner join
-- kuvab neid, kellel on DepartmentNmae all olemas väärtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada kõik andmed Employeest kätte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department -- võib kasutada ka left outer join-i
on Employees.DepartmentId = Department.Id

---näitab kõik töötajad Employee ja department tabelist
--- osakonna kuhu ei ole kedagi mahutatud
select Name, Gender, Salary, DepartmentName
from Employees
right join Department -- võib kasutada ka Right outer join-i
on Employees.DepartmentId = Department.Id

--- kuidas saada kõikide tabelite väärtused ühte päringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

---võtab kaks allpool olevat tabelit kokku ja 
--- korrutab need omavahel läbi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--- kuidas kuvada ainult isikud, kellel on Department NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine varjant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

-- kuidas saame department tabelise oleva rea kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--full join
-- mõlema tabeli mitte kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null