-- 1 tund

-- kommentaar
-- teeme andmebaasi e db
create database TARpe22

-- db kustutamine
drop database TARpe22

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

---- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

--- sama Id v''rtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
	Id int not null primary key,
	Name nvarchar(30),
	Email nvarchar(30),
	GenderId int
)

---vaatame Person tabeli sisu
select * from Person

---andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'wonderwoman', 'w@w.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Antman', 'ant"ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from Person

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

---kui sisestad uue rea andmeid ja ei ole sisestanud GenderId all v''rtust, siis
---see automaatselt sisetab tabelisse v''rtuse 3 ja selleks on unknown
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
add Age nvarchar(10)

--- lisame vanuse piirangu sisestamisel
--- ei saa lisada suuremat v''rtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale id, siis ei muuda midagi
delete from Person where Id = 9

select * from Person

-- kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothami linnas
select * from Person where City != 'Gotham'
-- teine variant
select * from Person where not City = 'Gotham'
-- kolmas variant
select * from Person where City <> 'Gotham'

-- n'itab teatud vanusega inimesi
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- n'itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcard e n�itab k�ik g-t�hega linnad
select * from Person where City like 'g%'
--n'itab, k]ik emailid, milles on @ m�rk
select * from Person where Email like '%@%'

--- n�itab k�iki, kellel ei ole @-m�rki emailis
select * from Person where Email not like '%@%'

--- n'itab, kellel on emailis ees ja peale @-m�rki
-- ainult �ks t�ht
select * from Person where Email like '_@_.com'

-- k]ik, kellel ei ole nimes esimene t'ht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning
-- �le 30 eluaasta
select * from Person where 
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t'hestikulises j�rjekorras inimesi 
--- ja v�tab aluseks nime

select * from Person order by Name
-- kuvab vastupidises j�rjekorras
select * from Person order by Name desc

-- v�tab kolm esimest rida
select top 3 * from Person

--- 2 tund
--- muudab Age muutuja int-ks ja n�itab vanuselises j�rjestuses
select * from Person order by CAST(Age as int)

--- k�ikide isikute koondvanus
select SUM(CAST(Age as int)) from Person

--- n�itab, k�ige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- n�itab, k�ige nooremat isikut
select Max(CAST(Age as int)) from Person

-- n�eme konkreetsetes linnades olevate isikute koondvanust
-- enne oli Age string, aga p�ringu ajal muutsime selle int-ks
select City, SUM(cast(Age as int)) as TotalAge from Person group by City

--kuidas saab koodiga muuta tabeli andmet��pi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int

-- kuvab esimeses reas v�lja toodud j�rjestuses ja muudab Age-i TotalAge-ks
-- teeb j�rjestuse vaatesse: City, GenderId ja j�rjestab omakorda City veeru j�rgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--- n�itab, et mitu rida on selles tabelis
select COUNT(*) from Person

--- veergude lugemine
SELECT count(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Person'

--- n�itab tulemust, et mitu inimest on genderId
--- v��rtusega 2 konkreetses linnas
--- arvutab kokku vanuse
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--- n'itab, et mitu inimest on vanemad, kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

-- loome uue tabelid
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
[Location] nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
FirstName nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (2, 'Pam', 'Female', 3000, 3)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (3, 'John', 'Male', 3500, 1)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (4, 'Sam', 'Male', 4500, 2)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (5, 'Todd', 'Male', 2800, 2)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (6, 'Ben', 'Male', 7000, 1)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (7, 'Sara', 'Female', 4800, 3)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (8, 'Valarie', 'Female', 5500, 1)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (9, 'James', 'Male', 6500, NULL)
insert into Employees (Id, FirstName, Gender, Salary, DepartmentId)
values (10, 'Russell', 'Male', 8800, NULL)


insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')


select FirstName, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

---arvutame [he kuu palgafondi
select SUM(CAST(Salary as int)) from Employees
--- min palga saaja ja kui tahame max palga saajat, 
--- siis min asemele max
select min(CAST(Salary as int)) from Employees

---lisame veeru nimega City
alter table Employees
add City nvarchar(30)

select * from Employees

-- [he kuu palgafond linnade l]ikes
select City, SUM(CAST(Salary as int)) as TotalSalary 
from Employees
group by City

--linnad on t'hestikulises j'rjestuses
select City, SUM(CAST(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
order by City

---  loeb 'ra, mitu inimest on nimekirjas
select COUNT(*) from Employees

--- vaatame, et mitu t;;tajat on soo ja linna kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employees(s)]
from Employees
group by Gender, City

--n'itada k]iki mehi linnade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--- n'itab ainult k]ik naised linnade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--- vigane p'ring
select * from Employees where SUM(CAST(Salary as int)) > 4000

-- t;;tav variant
select Gender, City, SUM(CAST(Salary as int)) as [Total Salary],
COUNT (Id) as [Total Employee(s)]
from Employees group by Gender, City
having SUM(CAST(Salary as int)) > 4000

--- loome tabeli, milles kahatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')

select * from Test1

---inner join
-- kuvab neid, kellel on DepartmentName all olemas v''rtus
select FirstName, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada k]ik andmed Employees-st k'tte
select FirstName, Gender, Salary, DepartmentName
from Employees
left join Department  --v]ib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- n'itab k]ik t;;tajad Employee tabelist ja Department tabelist
--- osakonna, kuhu ei ole kedagi m''ratud
select FirstName, Gender, Salary, DepartmentName
from Employees
right join Department  --v]ib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- kuidas saada k]ikide tabelite v''rtused ]hte p'ringusse
select FirstName, Gender, Salary, DepartmentName
from Employees
full outer join Department  
on Employees.DepartmentId = Department.Id

--- v]tab kaks allpool olevat tabelit kokku ja 
--- korrutab need omavahel l'bi
select FirstName, Gender, Salary, DepartmentName
from Employees
cross join Department

--- kuidas kuvada ainult need isikud, kellel on Department NULL
select FirstName, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine variant
select FirstName, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

-- kuidas saame deparmtent tabelis oleva rea, kus on NULL
select FirstName, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

-- full join
-- m]lema tabeli mitte-kattuvate v''rtustega read kuvab v'lja
select FirstName, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

---- 3 tund 28.03.2023

-- tabeli muutmine koodiga, alguses vana tabeli nimi ja 
-- siis uus soovitud nimi
sp_rename 'Department123', 'Department'

-- kasutame Employees tabeli asemel l[hendit E ja M
select E.FirstName as Employee, M.FirstName as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


--alter table Employees
--add VeeruNimi int

--- inner join
--- n'itab ainult managerId all olevate isikute v''rtuseid
select E.FirstName as Employee, M.FirstName as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--- k]ik saavad k]ikide [lemused olla
select E.FirstName as Employee, M.FirstName as Manager
from Employees E
cross join Employees M

select ISNULL('Asdasdasd', 'No Manager') as Manager

--- NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

--- neil kellel ei ole [lemust, siis paneb neile No Manager teksti
select E.FirstName as Employee, ISNULL(M.FirstName, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


-- lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

select * from Employees
--- uuendame koodiga v''rtuseid
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

select * from Employees

--igast reast v]tab esimesena t'idetud lahtri ja kuvab ainult seda
select  Id, coalesce(FirstName, MiddleName, LastName) as FirstName
from Employees

-- loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
FirstName nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
FirstName nvarchar(25),
Email nvarchar(25)
)

--- sisestame tabelisse andmeid
insert into IndianCustomers(FirstName, Email) values 
('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers(FirstName, Email) values 
('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--- kasutame union all, mis n'itab k]iki ridu
select Id, FirstName, Email from IndianCustomers
union all
select Id, FirstName, Email from UKCustomers

--- korduvate v''rtustega read pannakse [hte ja ei korrata
select Id, FirstName, Email from IndianCustomers
union
select Id, FirstName, Email from UKCustomers

-- kuidas sorteerida tulemust nime j'rgi
select Id, FirstName, Email from IndianCustomers
union all
select Id, FirstName, Email from UKCustomers
order by FirstName

--- stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

-- n[[d saab kasutada selle nimelist stored proceduret
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--muutujaid defineeritakse @ m'rgiga
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees
	where Gender = @Gender
	and DepartmentId = @DepartmentId
end

-- kindlasti tuleb sellele panna parameeter l]ppu
-- kuna muidu annab errori
-- kindlasti peab j'lgima j'rjekorda, mis on pandud sp-le
-- parameetrite osas
spGetEmployeesByGenderAndDepartment 'Male', 1


spGetEmployeesByGenderAndDepartment 
@DepartmentId = 1 , @Gender = 'Male'

-- saab vaadata sp sisu
sp_helptext spGetEmployeesByGenderAndDepartment

---3 tund

--- kuidas muuta sp-d v�tit peale et leegi teine peale teie
--- ei saaks seda muuta

alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb v�tme peale
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end
--sp tegemine
create proc spGetEmployeesCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = COUNT(Id) from Employees Where Gender = @Gender
end

---annab tulmuse kus loendab �ra n�uetele vastavd read
--- prindib tulemuse kirja teel
declare @TotalCount int
execute spGetEmployeesCountByGender 'asd', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount

---
declare @TotalCount int
execute spGetEmployeesCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--- sp sisu vaatmine
sp_help spGetEmployeesCountByGender
-- tabeli info
sp_help Employees
-- kui soovd sp teksti n�ha
�p_helptext spGetEmployeesCountByGender

-- vaatame millest s�ltub see sp
sp_depends spGetEmployeescountByGender
--- saame teada mitu asja s�ltub sellest tabelsit 
sp_depends Employees

create proc spGetNameById
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = Id, @FirstName = FirstName from Employees
end

spGetNameById 1, 'Tom'

create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = COUNT(Id) from Employees
end

--- saame tead et midu rida andmeid on tabelis
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees

-- mis Id all on keegi nime j�rgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

-- annab tulemuse kus id 1 real on keegi koos nimega
declare @FirstName nvarchar(50)
execute spGetNameById1 6, @FirstName output
print 'FirstName of the employee= ' + @FirstName

declare
@FirstName nvarchar(20)
execute spGetNameById1 1, @FirstName out
print 'FirstName = ' + @FirstName

create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

--- tuleb veateade kuna kutsusime v�lja int-i aga Tom on String andmet��p
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'FirstName of the employee= ' + @EmployeeName


--- sisseehitatud string funktsioon
--- see konverseerib ASCII t�he v��rtuse numbriks
select ASCII('a')
--- n�itab A-t�hte
select CHAR (69)

---prindime kogu t�hestiku v�lja
declare @Start int
set @Start = 97
while (@Start <=122)
begin
	select CHAR (@Start)
	set @Start = @Start+1
end

---eemaldame t�hjad kohad sulgudes
select LTRIM('						Hello')

--- t�hikute eemaldamine veerust
select *  from dbo.Employees

---Collumn Renaming
sp_rename 'Employees.Name', 'FirstName'

select LTRIM(FirstName) as [FirstName], MiddleName, LastName from Employees

select RTRIM('                   Hello                  ')

--- keerab kooloni sees olevad andmed vastupidiseks
--- vastavalt upper ja lower-ga saan muutqa m�rkide suurust
--- reverse funktsioon p��rab k�ik �mber
select REVERSE(UPPER(ltrim(FirstName))) as FirstName, MiddleName, LOWER(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName as FullName
from Employees

--n�itab plaju t�he m�rke mitu on nimes ja loeb t�hikud sisse
select FirstName, LEN(FirstName) as [Total Characters] from Employees

--- n�eb �ra mitu t�hte on s�nal ja ei loe t�hikud sisse
select FirstName, LEN(ltrim(FirstName)) as [Total Characters] from Employees

---left, right, substring
--- vasakult poolt neli esimest t�hte
select LEFT('ABCDEF', 4)

---paremalt poolt kolm t�hte
select Right('ABCDEF', 3)

---- kuvab @-t�hem�rgi asetust
select CHARINDEX('@', 'sara@aaa.com')

---esimene nr peale komakohta n�itab mitmendas alustab
--- ja siis mitu nr peae seda kuvab
select SUBSTRING('pam@bcd.com', 5,2)

--@- m�rgist kuvab kolm t�hem�rki viimase nr saab m��rata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

----peale @ t�hem�rki reguleerin t�hhe pikkuse n�itamist
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
LEN('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

--- saame teada domeeninimed emailides
select SUBSTRING (Email, CHARINDEX('@', Email) + 1,
LEN (Email) - charindex('@', Email)) as EmailDomain
from Employees

alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@aaa.com' where Id = 5
update Employees set Email = 'Ben@bbb.com' where Id = 6
update Employees set Email = 'Sara@aaa.com' where Id = 7
update Employees set Email = 'Valerie@bbb.com' where Id = 8
update Employees set Email = 'James@aaa.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

select * from Employees

--- lisame *m�rgiga teatud kohast
select FirstName, LastName,
	SUBSTRING(Email,1, 2) + REPLICATE('*', 5) + --- peale teist t�hem�rki paneb viis
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - CHARINDEX('@', Email)+1) as Email --- kuni @- m�rgini on d�naamiline0
from Employees

--- kolm korda n�itab stringis olevat v��rtust
select REPLICATE('asd', 3)

--- kuidas sisestada t�hikud kahe nime vahele
select SPACE(5)

--- t�hikute arv kahe nime vahel
select FirstName + SPACE(25) + LastName as FullName
from Employees

--- PATINDEX
--- sama mis CHARINDEX aga d�naamiliselm ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 -- leiab k�ik selle domeeni esindajad
-- ja alates mitmendast m�rgist algab @

--- k�ik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees

--- soovin asendada peale esimest m�rki kolme t�hte viie t�rniga
select FirstName, LastName, Email,
	STUFF(Email, 2, 3, '*****') as StuffedEmail
from Employees

--- teeme tabeli
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--- konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
VALUES (GETDATE), GETDATE(),GETDATE())

update DateTime set c-c_datetimeoffset = '2022-04-11 11:50:34 9100000 +00:00'
where c_datetimeoffset = '23-04-11 11:50:34.9100000 +00.00'
