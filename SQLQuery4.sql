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
Name nvarchar(50),
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


select Name, Gender, Salary, DepartmentName
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
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada k]ik andmed Employees-st k'tte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department  --v]ib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- n'itab k]ik t;;tajad Employee tabelist ja Department tabelist
--- osakonna, kuhu ei ole kedagi m''ratud
select Name, Gender, Salary, DepartmentName
from Employees
right join Department  --v]ib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- kuidas saada k]ikide tabelite v''rtused ]hte p'ringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department  
on Employees.DepartmentId = Department.Id

--- v]tab kaks allpool olevat tabelit kokku ja 
--- korrutab need omavahel l'bi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--- kuidas kuvada ainult need isikud, kellel on Department NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

-- kuidas saame deparmtent tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

-- full join
-- m]lema tabeli mitte-kattuvate v''rtustega read kuvab v'lja
select Name, Gender, Salary, DepartmentName
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
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


--alter table Employees
--add VeeruNimi int

--- inner join
--- n'itab ainult managerId all olevate isikute v''rtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--- k]ik saavad k]ikide [lemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select ISNULL('Asdasdasd', 'No Manager') as Manager

--- NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

--- neil kellel ei ole [lemust, siis paneb neile No Manager teksti
select E.Name as Employee, ISNULL(M.Name, 'No Manager') as Manager
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
select  Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

-- loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--- sisestame tabelisse andmeid
insert into IndianCustomers(Name, Email) values 
('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers(Name, Email) values 
('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--- kasutame union all, mis n'itab k]iki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--- korduvate v''rtustega read pannakse [hte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

-- kuidas sorteerida tulemust nime j'rgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

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


--- 3 tund

--- kuidas muuta sp-d ja v]ti peale, et keegi teine peale teie 
--- ei saaks seda muuta

alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb v]tme peale
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = COUNT(Id) from Employees where Gender = @Gender
end

--- annab tulemuse, kus loendab 'ra n]uetele vastavad read
--- prindib tulemuse kirja teel
declare @TotalCount int
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount
go
--- n'itab 'ra, et mitu rida vastab n]uetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
-- tabeli info
sp_help Employees
-- kui soovid sp teksti n'ha
sp_helptext spGetEmployeeCountByGender

-- vaatame, millest s]ltub see sp
sp_depends spGetEmployeeCountByGender
--- saame teada, mitu asja s]ltub sellest tabelist
sp_depends Employees


create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Name = Id, @Name = FirstName from Employees
end

spGetNameById 1, 'Tom'
-- annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = COUNT(Id) from Employees
end

--- saame teada, et mitu rida andmeid on tabelis
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees

-- mis id all on keegi nime j'rgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

-- annab tulemuse, kus id 1 real on keegi koos nimega
declare @FirstName nvarchar(50)
execute spGetNameById1 6, @FirstName output
print 'Name of the employee = ' + @FirstName


declare
@FirstName nvarchar(20)
execute spGetNameById1 1, @FirstName out
print 'Name = ' + @FirstName


create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

--- tuleb veateade kuna kutsusime v'lja int-i, aga Tom on string andmet[[p
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

--- 

--- sisseehitatud string funktsioon
--- see konverteerib ASCII t�he v��rtuse numbriks
select ASCII('a')
--- n�itab A-t�hte
select CHAR (65)

--- prindime kogu t�hestiku v�lja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select CHAR (@Start)
	set @Start = @Start+1
end

---eemaldame t�hjad kohad sulgudes (vasakul pool)
select LTRIM('                           Hello')

--- t�hikute eemldamine veerust
select * from dbo.Employees

-- t�hikute eemaldamine veerust
select ltrim(FirstName) as [First Name], MiddleName, LastName from Employees

--paremalt poolt t�hjad stringid l�ikab �ra
select RTRIM('     Hello              ')

--- keerab kooloni sees olevad andmed vastupidiseks
--- vastavalt upper ja lower-ga saan muuta m�rkide suurust
--- reverse funktsioon p��rab k�ik �mber
select REVERSE(UPPER(ltrim(FirstName))) as FirstName, MiddleName, LOWER(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

-- n�eb �ra, et mitu t�hem�rki on nimes ja loeb t�hikud sisse
select FirstName, LEN(FirstName) as [Total Characters] from Employees

--- n�eb �ra, mitu t�hte on s�nal ja ei loe tyhikuid sisse
select FirstName, LEN(ltrim(FirstName)) as [Total Characters] from Employees


---left, right, substring
--- vasakult poolt neli esimest t�hte
select LEFT('ABCDEF', 4)

--- paremalt poolt kolm t�hte
select Right('ABCDEF', 3)

---- kuvab @-t�hem�rgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--- esimene nr peale komakohta n'itab, et mitmendast alustab
--- ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@abc.com', 5,4)

-- @-m'rgist kuvab kolm t'hem'rki. Viimase nr-ga saab m''rata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

---- peale @-t'hem'rki reguleerin t'hem'rkide pikkuse n'itamist
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
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

select * from Employees


--- lisame *-m�rgi teatud kohast
select FirstName, LastName,
	SUBSTRING(Email,1, 2) + REPLICATE('*', 5) + --- peale teist t�hem�rki paneb viis t�rni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email)+1) as Email --- kuni @-m'rgini e on d[naamiline
from Employees

--- kolm korda n'itab stringis olevat v''rtust
select REPLICATE('asd', 3)

---- kuidas sisestada tyhikut kahe nime vahele
select SPACE(5)

--- t�hikute arv kahe nime vahel
select FirstName + SPACE(25) + LastName as FullName
from Employees

---PATINDEX
--- sama, mis CHARINDEX, aga d�naamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 -- leiab k�ik selle domeeni esindajad
-- ja alates mitmendast m�rgist algab @

--- k]ik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees

--- soovin asendada peale esimest m�rki kolm t�hte viie t�rniga
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

---konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

select * from DateTime

update DateTime set c_datetimeoffset = '2022-04-11 11:50:34.9100000 +00:00'
where c_datetimeoffset = '2023-04-11 11:50:34.9100000 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja p�ring
select SYSDATETIME(), 'SYSDATETIME' -- veel t�psem aja p�ring
select SYSDATETIMEOFFSET() --- t�pne aeg koos ajalise nihkega UTC suhtes
select GETUTCDATE()  --- UTC aeg


select ISDATE('asd') -- tagastab 0 kuna string ei ole date
select ISDATE(GETDATE())  --- tagastab 1 kuna on kp
select ISDATE('2023-04-11 11:50:34.9100000') -- tagastab 0 kuna max kolm komakohta v�ib olla
select ISDATE('2023-04-11 11:50:34.910') --tagastab 1
select DAY(GETDATE()) --annab t�nase p�eva nr
select DAY('03/31/2020') --anab stringis oleva kp ja j�rjestus peab olema �ige
select MONTH(GETDATE()) -- annab jooksva kuu nr
select Month('03/31/2020') -- annab stringis oleva kuu nr
select Year(GETDATE()) -- annab jooksva aasta nr
select Year('03/31/2020') -- annab stringis oleva aasta nr

select DATENAME(DAY, '2023-04-11 11:50:34.910') -- annab stringis oleva p�eva nr
select DATENAME(WEEKDAY, '2023-04-11 11:50:34.910') --annab stringis oleva p�eva s�nana
select DATENAME(MONTH, '2023-04-11 11:50:34.910') --annab stringis oleva kuu s�nana

--- 5 tund 18.04.2023
create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
		select @tempdate = @DOB

		select @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - case when (MONTH(@DOB) > 
		MONTH(GETDATE())) or (MONTH(@DOB)
		= month(getdate()) and DAY(@DOB) > DAY(GETDATE())) then 1 else 0 end
		select @tempdate = DATEADD(YEAR, @years, @tempdate)

		select @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - case when DAY(@DOB) > 
		DAY(GETDATE()) then 1 else 0 end
		select @tempdate = DATEADD(MONTH, @months, @tempdate)

		select @days = DATEDIFF(DAY, @tempdate, GETDATE())

	declare @Age nvarchar(50)
		set @Age = 
		CAST(@years as nvarchar(4)) + ' Years ' 
		+ CAST(@months as nvarchar(4)) + ' Months '  
		+ CAST(@days as nvarchar(4)) + ' Days old '
	return @Age
end

alter table Employees
add DateOfBirth datetime

-- saame vaadata kasutajate vanust
select Id, FirstName, DateOfBirth, dbo.fnComputeAge(DateOfBirth) 
as Age from Employees

-- kui kasutame seda funktsiooni, siis saame teada t�nase p�eva vahe
-- stringis v�lja toodud kuup�evaga
select dbo.fnComputeAge('11/11/2010')

-- nr peale DateOfBirth muutujat n�itab, et mismoodi kuvada DOB
select Id, FirstName, DateOfBirth,
CONVERT(nvarchar, DateOfBirth, 103) as ConvertedDOB
from Employees

select Id, FirstName, FirstName + ' - ' + CAST(Id as nvarchar)
as [Name-Id] from Employees


select CAST(GETDATE() as date) -- t�nane kp
select CONVERT(date, GETDATE()) -- t�nane k

--matemaatilised funktsioonid
select ABS(-101.5) --abs on absoluutne nr ja tulemuseks saame ilma miinusm�rgita tulemuse
select CEILING(15.2) --tagastab 16 ja suurendab suurema t�isarvu suunas
select CEILING(-15.2) --tagastab -15 ja suurendab suurema positiivse t�isarvu suunas
select floor(15.2) -- �mardab negatiivsema nr poole
select floor(-15.2) -- �mardab negatiivsema nr poole
select POWER(2, 4) -- hakkab korrutama 2*2*2*2, esimene nr on korrutatav nr
select SQUARE(9) --antud juhul 9 ruudus
select SQRT(81)  --annab vastuse 9, ruutjuur

select RAND() ---annab suvalise nr
select FLOOR(RAND() * 100) --korrutab sajaga iga suvalise nr


---- 6 tund

---iga kord n'itab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
	begin
		print floor(rand() * 1000)
		set @counter = @counter + 1
end

select ROUND(850.556, 2) -- �mardab kaks kohta peale komat 850.560
select ROUND(850.556, 2, 1) --�mardab allapoole 850.550
select ROUND(850.556, 1) --�mardab �lespoole ja ainult esimene nr peale koma 850.600
select ROUND(850.556, 1, 1) --�mardab allpoole
select ROUND(850.556, -2) --�mardab esimese t�isnr �lesse
select ROUND(850.556, -1) --�mardab esimese t�isnr alla


---
create function dbo.CalculateAge (@DOB date)
returns int
as begin
declare @Age int
set @Age = DATEDIFF(YEAR, @DOB, GETDATE()) -
	case
		when (MONTH(@DOB) > MONTH(GETDATE())) or
			 (MONTH(@DOB) > MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
		then 1
		else 0
		end
	return @Age
end

execute CalculateAge '10/08/2020'

select * from Employees

-- arvutab v�lja, kui vana on isik ja v�tab arvesse kuud ning p�evad
-- antud juhul n�itab k�ike, kes on �le 36 a vanad
select Id, FirstName, dbo.CalculateAge(DateOfBirth) as Age
from Employees
where dbo.CalculateAge(DateOfBirth) > 36

---lisame veeru juurde
alter table Employees
add DepartmentId int

-- scalar function annab mingis vahemikus olevaid andmeid,
-- aga inline table values ei kasuta begin ja end funktsioone
-- scalar annab v��rtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, FirstName, DateOfBirth, DepartmentId, Gender
		from Employees
		where Gender = @Gender)

--- k�ik female t��tajad
select * from fn_EmployeesByGender('Female')

select * from fn_EmployeesByGender('Female')
where FirstName = 'Pam' --where abil saab otsingut t�psustada

select * from Department

--- kahest erinevast tabelist andmete v�tmine ja koos kuvamine
--- esimene on funktsioon ja teine tabel
select FirstName, Gender, DepartmentName
from fn_EmployeesByGender('Female') 
E join Department D on D.Id = E.DepartmentId

--- multi-table statment

-- inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, FirstName, CAST(DateOfBirth as date)
		as DOB
		from Employees)

select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
create function fn_MS_GetEmployees()
returns @Table Table (Id int, FirstName nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, FirstName, CAST(DateOfBirth as date) from Employees

	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini t��tamas kuna k�sitletakse vaatena
--multi puhul on pm tegemist stored proceduriga ja kulutab rohkem ressurssi

-- saab andmeid muuta
update fn_GetEmployees() set FirstName = 'Sam1' where Id = 1
-- ei saa muuta andmeid multistate puhul
update fn_MS_GetEmployees() set FirstName = 'Sam2' where Id = 1

select * from Employees

--ette m��ratud ja mitte-ettem��ratud

select COUNT(*) from Employees
select SQUARE(3) --k�ik tehtem�rgid on ette m��ratud funktsioonid
-- ja sinna kuuluvad veel sum, avg ja square

-- mitte-ettem��ratud
select GETDATE()
select CURRENT_TIMESTAMP
select RAND() --see funktsioon saab olla m�lemas kategoorias,
-- k�ik oleneb sellest, kas sulgudes on 1 v�i ei ole

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
	return (select FirstName from Employees where Id = @id)
end

select dbo.fn_GetNameById(7)

sp_helptext fn_GetNameById

-- loome funktsiooni, mille sisu kr�pteerime �ra
create function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
as begin
	return (select FirstName from Employees where Id = @id)
end

-- muudame funktsiooni sisu ja kr�pteerime �ra
alter function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
with encryption
as begin
	return (select FirstName from Employees where Id = @id)
end

--tahame kr�pteeritud funktsiooni sisu n�ha, aga ei saa
sp_helptext fn_GetEmployeeNameById

alter function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
with schemabinding
as begin
	return (select FirstName from Employees where Id = @id)
end

--- temporary tables
-- #-m�rgi ette panemisel saame aru, et tegemist on temp tableiga
-- seda tabelit saab ainult selles p�ringus avada
create table #PersonDetails(Id int, FirstName nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')
-- teie �lesanne on otsida �lesse temporary tabel

select * from #PersonDetails

select Name from sysobjects
where Name like '#PersonDetails%'

--- kustutame temp table
drop table #PersonDetails

-- teeme stored procedure
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, FirstName nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--- globaalse temp tabeli tegemine
create table ##PersonDetails(Id int, FirstName nvarchar(20))

select * from Employees

select * from Employees
where Salary > 5000 and Salary < 7000

--- loome indeksi, mis asetab palga kahanaevasse j�rjestusse
create index IX_Employee_Salary
on Employees (Salary asc)

-- saame tead, et mis on selle tabeli primaarv�ti ja index
exec sys.sp_helpindex @objname = 'Employees'

--- indeksi kustutamine
drop index Employees.IX_Employee_Salary

---indeksi t��bid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. T�istekst
--7. Ruumiline
--8. Veerus�ilitav
--9. Veergude indeksid
--10. V�lja arvatud veergude indeksid

create table EmployeeCity
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(20)
)

exec sp_helpindex EmployeeCity
--- andmete �ige j�rjestuse loovad klastris olevad indeksid ja kasutab selleks Id nr-t
-- p�hjus, miks antud juhul kasutab Id-d, tuleneb primaarv�tmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

select * from EmployeeCity

--klastris olevad indeksid dikteerivad s�ilitatud andmete j�rjestuse tabelis
--ja seda saab klastrite puhul olla ainult �ks

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

--annab veateate, et tabelis saab olla ainult �ks klastris olev indeks
-- kui soovid, uut indeksit luua, siis kustuta olemasolev

-- saame luua ainult �he klastris oleva indeksi tabeli peale
-- klastris olev indeks on analoogne telefoni suunakoodile

-- loome composite(�hend) index-i
-- enne tuleb k�ik teised klastris olevad indeksid �ra kustutada

create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)

drop index EmployeeCity.PK__Employee__3214EC07A2F8A69D
-- koodiga ei saa kustutada Id-d, aga k�sitsi saab

select * from EmployeeCity

--- erinevused kahe indeksi vahel
--- 1. ainult �ks klastris olev indeks saab olla tabeli peale, 
--- mitte-klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--- Juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks m��ratleb �ra tabeli ridade slavestusj�rjestuse
--- ja ei n�ua kettal lisa ruumi. Samas mitte klastris olevad indeksid on 
--- salvestatud tabelist eraldi ja n�uab lisa ruumi

create table EmployeeFirstName
(
Id int primary key,
FirstName nvarchar(50),
LastName nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(25)
)

exec sp_helpindex EmployeeFirstName

--ei saa sisestada kahte samasuguse Id v��rtusega rida
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Mendoz', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC0714697DE1
-- SQL server kasutab UNIQUE indeksit j�ustamaks v��rtuse unikaalsust 
-- ja primaarv�tit

-- unikaalsed indekseid kasutatakse kindlustamaks v��rtuste unikaalsust 
-- (sh primaarv�tme oma)


create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, LastName)

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(2, 'John', 'Mendoz', 2500, 'Male', 'London')

truncate table EmployeeFirstName

-- lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstname_City
unique nonclustered(City)

--ei luba tabelisse v��rtusega uut John Menoz-t lisada kuna see on juba olemas
insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3500, 'Male', 'London')

--- saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName


-- 1.Vaikimisi primaarv�ti loob unikaalse klastris oleva indeksi, samas 
-- unikaalne piirang loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit v�i piirangut ei saa luua olemasolevasse tabelisse, 
-- kui tabel juba sisaldab v��rtusi v�tmeveerus
-- 3. Vaikimisi korduvaid v��rtusied ei ole veerus lubatud,
-- kui peaks olema unikaalne indeks v�i piirang. Nt, kui tahad sisestada 
-- 10 rida andmeid, millest 5 sisaldavad korduvaid andmeid, siis k�ik 10 
-- l�katakse tagasi. Kui soovin ainult 5 rea tagasi l�kkamist ja �lej��nud 
-- 5 rea sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY

--koodin�ide:
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

--enne koodi sisestamist kustuta indeksi kaustas UQ_EmployeeFirstname_City �ra
insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3512, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Mendoz', 3123, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Mendoz', 3520, 'Male', 'London1')
-- enne ignore k�sku oleks k�ik kolm rida tagasi l�katud, aga
-- n��d l�ks keskmine rida l�bi kuna linna nimi oli unikaalne

--- view

--- view on salvestatud SQL-i p�ring. Saab k�sitleda ka virtuaalse tabelina

select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id


-- loome view
create view vEmployeesByDepartment
as
	select FirstName, Salary, Gender, DepartmentName
	from Employees
	join Department
on Employees.DepartmentId = Department.Id

-- view p�ringu esile kutsumine
select * from vEmployeesByDepartment

-- view ei salvesta andmeid vaikimisi
-- seda tasub v�tta, kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks,
-- mitte IT-inimesele
-- piiratud ligip��s andmetele, ei n�e k�ik veerge

--- teeme view, kus n�eb ainult IT-t��tajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName --saab n�idata teatud arv veerge
from Employees
join Department
on Employees.DepartmentId = Department.Id
where Department.DepartmentName = 'IT'
-- seda p�ringut saab liigitada reataseme turvalisuse alla
-- tahan ainult IT inimesi n�idata

select * from vITEmployeesInDepartment

--saab kasutada esitlemaks koondandmeid ja �ksikasjalike andmeid
-- view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, COUNT(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--- 7tund 1414
--view muutmine
alter view vEmployeesCountByDepartment

-- view kustutamine
drop view vEmployeesCountByDepartment

--- view uuendused
-- kas l'bi view saab uuendada andmeid

--- teeme andmete uuenduse, aga enne teeme view
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

---teeme uuenduse
update vEmployeesDataExceptSalary
set FirstName = 'Sam' where Id = 1

select * from vEmployeesDataExceptSalary

--- kustutame ja sisestame andmeid
delete from vEmployeesDataExceptSalary where Id = 2

insert into vEmployeesDataExceptSalary where Id = 2
insert into vEmployeesDataExceptSalary (Id, Gender, DepartmentId, FirstName)
values(2, 'Male', 1, 'Tom')

--- indekseeritud view-d
-- MS SQL-s on indekseeritud view nime all ja
-- Oracle-s materjaliseeritud view

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product values 
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)


create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

--loome view, mis annab meile veerud TotalSlaes ja TotalTransaction

create view vTotalSalesByProduct
with schemabinding
as
select Name,
SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name


select * from vTotalSalesByProduct


--- kui soovid luua indeksi view sisse, siis peab j�rgima teatud reegleid
-- 1. view tuleb luua koos schemabinding-ga
-- 2. kui lisafunktsioon select list viitab v�ljendile ja selle tulemuseks
-- v�ib olla NULL, siis asendusv��rtus peaks olema t�psustatud. 
-- Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL v��rtust
-- 3. kui GroupBy on t�psustatud, siis view select list peab
-- sisaldama COUNT_BIG(*) v�ljendit
-- 4. Baastabelis peaksid view-d olema viidatud kahesosalie nimega
-- e antud juhul dbo.Product ja dbo.ProductSales.

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)
-- paneb selle view t�hestikulisse j�rjestusse

select * from vTotalSalesByProduct


--- view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, Name, Gender, DepartmentId
from
where Gender = @Gender

-- vaatesse ei saa kaasa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

--- funktsiooni esile kutsumine koos parameetriga
select * from fnEmployeeDetails('male')

--- order by kasutamine
create view vEmployeeDetailsSorted
as
select Id, FirstName, Gender, DepartmentId
from Employees
order by Id

-- order by-d ei saa kasutada view-s

-- temp table kasutamine

create table ##TestTempTable(Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values
(101, 'Martin', 'Male'),
(102, 'Joe', 'Female'),
(103, 'Pam', 'Female'),
(104, 'James', 'Male')

--- kasutame viewd, et kutsuda esile TempTable
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--- temp tables ei saa kasutada view-d

-- Triggerid
-- kolme t��pi triggerid: DML, DDL ja LOGON

-- trigger on stored procedure eriliik, mis automaatselt k�ivitub,
-- kui mingi tegevus peaks aandmebaasis aset leidma

-- DML - data manipulation language
-- DML-i p�hilised k�sklused: insert, update ja delete

-- DML triggereid saab klassifitseerida kahte t��pi:
-- 1. After trigger (kutsutakse ka FOR triggeriks)
-- 2. Instead of trigger (selmet trigger e selle asemel trigger)

--- after trigger k�ivitub peale s�ndmust, 
--- kui kuskil on tehtud insert, update ja delete

-- kasutame Employee tabelit

create table EmployeeAudit
(
	Id int identity(1, 1) primary key,
	AuditData nvarchar(1000)
)

-- peale ig at��taja sisestamist tahame teada saada t��taja Id-d, p�eva ning aega(millal sisestati)
-- k�ik andmed tulevad EmployeeAudit tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
	declare @Id int
	select @Id = Id from inserted
	insert into EmployeeAudit
	values ('New employee with Id = ' + CAST(@Id as nvarchar(5)) + ' is added at '
	+ CAST(GETDATE() as nvarchar(20)))
end

select * from Employees
select * from EmployeeAudit 

insert into Employees values (11, 'Male', 3000, 1, 'Bob')

select * from Employees
select * from EmployeeAudit 


-- update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldFirstName nvarchar(50), @NewFirstName nvarchar(50)

	-- muutuja, kuhu l�heb l�pptekst
	declare @AuditString nvarchar(1000)

	-- laeb k�ik uuendatud andmed temp table alla
	select * into #TempTable
	from inserted

	-- k�ib l�bi k�ik andmed temp tables-s
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		-- selekteerib esimese rea andmed temp table-st
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewFirstName = FirstName
		from #TempTable
		-- v�tab vanad andmed kustutatud tabelist
		select @OldGender = Gender, @OldSalary = Salary, 
		@OldDepartmentId = DepartmentId, @OldFirstName = FirstName
		from deleted where Id = @Id

		-- loob auditi stringi d�naamiliselt
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + CAST(@OldSalary as nvarchar(50)) 
			+ ' to ' + CAST(@NewSalary as nvarchar(50))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + CAST(@OldDepartmentId as nvarchar(50)) 
			+ ' to ' + CAST(@NewDepartmentId as nvarchar(50))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
			@NewFirstName

		insert into dbo.EmployeeAudit values (@AuditString)
		-- kustutab temp table-st rea, et saaksime liikuda uue rea juurde
		delete from #TempTable where Id = @Id
	end
end

update Employees set FirstName = 'test123456', Salary = 5000
where Id = 2

select * from EmployeeAudit
select * from Employees



--- insert trigger
select * from Department

update Department set DepartmentName = 'HR'
where Id = 3


alter view vEmployeeDetails 
as 
select Employees.Id, FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeeDetails

create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as
begin

	declare @DeptId int

	--vaatab, kas on olemas �iget DepartmentId
	-- vastavas p�ringus
	select @DeptId = Department.Id --kui keegi peaks mingi suvalise osakonnanime panema, siis vastus on null
	from Department
	join inserted
	on inserted.DepartmentName = Department.DepartmentName

	--kui departmentId on null, siis annab veateate
	--ja l�petab tegevuse
	if(@DeptId is null) --kui vastus on null, siis annab alloleva vastuse
	begin
	raiserror('Invalid Department Name. Statement terminated', 16, 1)
	return
	end

	--kui osakonna nimetus on korrektne
	insert into Employees(Id, FirstName, Gender, DepartmentId)
	select Id, FirstName, Gender, @DeptId
	from inserted
end

select * from EmployeeAudit
select * from Employees
select * from Department

insert into vEmployeeDetails values(12, 'asd', 'Female', '234534565678')

delete from Employees where Id = 12;

-- ei saa andmete uuendust teha kuna m�jutab mitut tabelit korraga
update vEmployeeDetails set FirstName = 'Johny', DepartmentName = 'IT' where Id = 1

--
update vEmployeeDetails set DepartmentName = 'IT' where Id = 1
select * from Department

-- loome triggeri
create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin
	--kui EmployeeId on uuendatud
	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	--kui Departmentname on uuendatud
	if(update(DepartmentName))
	begin
		declare @DeptId int

		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.DepartmentName = Department.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Invalid Department Name', 16, 1)
			return
		end

		update Employees set DepartmentId = @DeptId
		from inserted
		join Employees
		on Employees.Id = inserted.id
	end

	--kui Gender vereust on andmed uuendatud
	if(update(Gender))
	begin
		update Employees set Gender = inserted.Gender
		from inserted
		join Employees
		on Employees.Id = inserted.id
	end

	--Kui FirstName veerus on muudetud andmeid
	if(update(FirstName))
	begin
		update Employees set FirstName = inserted.FirstName
		from inserted
		join Employees
		on Employees.Id = inserted.id
	end
end

update Employees set FirstName = 'John', Gender = 'Female', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails
select * from Employees
select * from Department

-- delete trigger

create view vEmployeeCount
as
select DepartmentName, DepartmentId, count(*) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from vEmployeeCount

--n�itab , kus on rohkem, kui kaks t��tajat
select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

--temp  e ajutise tabeli loomine ja siis inf k�tte saamine
select DepartmentName, Department.Id, count(*) as TotalEmployees
into #TempEmployeeCount
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, Department.Id

select * from #TempEmployeeCount

--tabeli p�ring
select DepartmentName, TotalEmployees
from #TempEmployeeCount
where TotalEmployees >= 2

--kustutame temptabeli
drop table #TempEmployeeCount

--p�ring algab
declare @EmployeeCount 
table(DepartmentName nvarchar(20), DepartmentId int, TotalEmployees int)

insert @EmployeeCount
select DepartmentName, DepartmentId, count(*) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select DepartmentName, TotalEmployees
from @EmployeeCount
where TotalEmployees >= 2
-- p�ring l�ppeb

-- sulgudes koondame k�ik kokku ja v�tame
-- ainult esimese rea SELECT-i j�rel oleva kokku
select DepartmentName, TotalEmployees
from
	(
		select DepartmentName, DepartmentId, count(*) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		group by DepartmentName, DepartmentId
	)
as EmployeeCount
where TotalEmployees >= 2


--CTE e common table expression ja on sarnane tuletatud tabelile ja
-- ei ole talletatud objektile ja kestab p�ringu aja jooksul
-- tegemist on nagu temp tabeliga

with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as 
	(
		select DepartmentName, DepartmentId, count(*) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2


select * from Employees

with Employees_Name_Gender
as
(
select Id, FirstName, Gender from Employees
)
update Employees_Name_Gender set Gender = 'Male' where Id = 1


--- saame CTE abil teada, et mitu t��tajat on mingis osakonnas
with EmployeeCount(DepartmentId, TotalEmployees)
as
	(
		select DepartmentId, count(*) as TotalEmployees
		from Employees
		group by DepartmentId
	)
select DepartmentName, TotalEmployees
from Department
join EmployeeCount
on Department.Id = EmployeeCount.DepartmentId
order by TotalEmployees

--- saab kasutada ka rohkem, kui �hte CTE-d, aga peab komadega eraldama
with EmployeesCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
	(
		select DepartmentName, count(Employees.Id) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		where DepartmentName in ('Payroll', 'IT')
		group by DepartmentName
	),
EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
	(
		select DepartmentName, count(Employees.Id) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		where DepartmentName in ('HR', 'Admin')
		group by DepartmentName
	)
select * from EmployeesCountBy_Payroll_IT_Dept
union
select * from EmployeesCountBy_HR_Admin_Dept

---- updatable CTE
select * from Employees

-- saab muuta Gender veerus olevat v��rtust
with EmployeesByDepartment
as
(
	select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

select * from Employees

--- kuvab andmed selliselt, et nr asemel on osakonna nimed
--- CTE kahe baastabeli p�hjal
with EmployeesByDepartment
as
(
	select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
select * from EmployeesByDepartment

--muudame Johni tagasi male peale

with EmployeesByDepartment
as
(
	select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

--tahame kahte baastabelit muuta
--aga ei saa e ainult �ks baastabel korraga
with EmployeesByDepartment
as
(
	select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male', DepartmentName = 'IT' where Id = 1


--- recrusive CTE

create table Employee
(
EmployeeId int primary key,
Name nvarchar(20),
ManagerId int
)

Insert into Employee values 
(1, 'Tom', 2),
(2, 'Josh', null),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)


select emp.Name as [Employee Name],
isnull(manager.Name, 'Super Boss') as [Manager Name]
from Employee emp
left join Employee manager
on emp.ManagerId = manager.EmployeeId

--- koht, kus tabelis on null, sinna pannakse nimi Super Boss
--- CTE tabel on ainult p�ringu ajaks m�eldud tabel

with
	EmployeeCTE (EmployeeId, Name, ManagerId, [Level])
	as
	(
		select EmployeeId, Name, ManagerId, 1
		from Employee
		where ManagerId is null

		union all

		select Employee.EmployeeId, Employee.Name,
		Employee.ManagerId, EmployeeCTE.[Level] + 1
		from Employee
		join EmployeeCTE
		on Employee.ManagerId = EmployeeCTE.EmployeeId
	)
select EmpCTE.Name as Employee, IsNull(MgrCTE.Name, 'Super Boss') as Manager,
EmpCTE.[Level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId

-- k�igile annab department tabelis �he numbri juurde ja j�rjestab employee 
-- tabelis olevad isikud �ra.

--- kokkuv�te CTE-st
-- 1. kui CTE baseerub �hel tabelil, siis uuendus t��tab
-- 2. kui CTE baseerub mitmel tabelil, siis tuleb veateade
-- 3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult �hte
-- tabelit, siis uuendus saab tehtud

---- PIVOT tabel

create table ProductSales
(
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

insert into ProductSales values
('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),

('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),

('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),

('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'UK', 360),
('David', 'UK', 140)

--
select SalesCountry, SalesAgent, SUM(SalesAmount)
as Total
from ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--pivot n�ide
select SalesAgent, India, Us, UK
from ProductSales
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable

-- p�ring muudab unikaalsete veergude v��rtust (India, US ja UK)
-- SalesCountry veerus omaette veergudeks koos veergude SalesAmount liitmisega

create table ProductsWithId
(
	Id int primary key,
	SalesAgent nvarchar(50),
	SalesCountry nvarchar(50),
	SalesAmount int
)

insert into ProductsWithId values
(1, 'Tom', 'UK', 200),
(2, 'John', 'US', 180),
(3, 'John', 'UK', 260),
(4, 'David', 'India', 450),
(5, 'Tom', 'India', 350),

(6, 'David', 'US', 200),
(7, 'Tom', 'US', 130),
(8, 'John', 'India', 540),
(9, 'John', 'UK', 120),
(10, 'David', 'UK', 220),

(11, 'John', 'UK', 420),
(12, 'David', 'US', 320),
(13, 'Tom', 'US', 340),
(14, 'Tom', 'UK', 660),
(15, 'John', 'India', 430),

(16, 'David', 'India', 230),
(17, 'David', 'India', 280),
(18, 'Tom', 'UK', 480),
(19, 'John', 'UK', 360),
(20, 'David', 'UK', 140)

select SalesAgent, India, US, UK
from ProductsWithId
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable
--- tulemuse p�hjuseks on Id veeru olemasolu tabelis
--- ja mida v�etakse arvesse p��ramise ja grupeerimise j�rgi

select SalesAgent, India, US, UK
from
(
	select SalesAgent, SalesCountry, SalesAmount
	from ProductsWithId
)
as SourceTable
pivot
(
	sum(SalesAmount) for SalesCountry in (India, US, UK)
)
as PivotTable

-- 07.06.2023

select Id, FromAgentOrCountry, CountryOrAgent
from
(
	select Id, SalesAgent, SalesCountry, SalesAmount
	from ProductsWithId
) as SourceTable
unpivot
(
CountryOrAgent for FromAgentOrCountry in 
(SalesAgent, SalesCountry)
)
as PivotTabel

--- transaction

-- j�lgib j�rgmisi samme:
-- 1. selle algus
-- 2. k�ivitab DB k�ske
-- 3. kontrollib vigu. Kui on viga, siis taastab algse oleku

create table MailingAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetAddress nvarchar(50),
	City nvarchar(10),
	PostalCode nvarchar(20)
)

insert into MailingAddress
values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create table PhysicalAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetAddress nvarchar(50),
	City nvarchar(10),
	PostalCode nvarchar(20)
)

insert into PhysicalAddress
values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

-- loome sp
create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

--k�ivitame sp
spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress

alter proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON 12'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

--k�ivitame sp
spUpdateAddress
go
select * from MailingAddress
go
select * from PhysicalAddress

-- kui teine uuendus ei l�he l�bi, siis esimene ei l�he ka l�bi
-- k�ik uuendused peavad l�bi minema

--- transaction ACID test
-- edukas transaction peab l�bima ACID testi:
-- A - atomic e aatomlikus
-- C - consistent e j�rjepidevus
-- I - isolated e isoleeritus
-- D - durable e vastupidav

--- Atomic - k�ik tehingud transactionis on kas edukalt t�idetud v�i need 
-- l�katakse tagasi. Nt, m�lemad k�sud peaksid alati �nnesutma. Andmebaas 
-- teeb sellisel juhul: v�tab esimese update tagasi ja veeretab selle algasendisse
-- e taastab algsed andmed

--- Consistent - k�ik transactioni puudutavad andmed j�etakse loogiliselt 
-- j�rjepidevasse olekusse. Nt, kui laos saadaval olevaid esemete hulka 
-- v�hendatakse, siis tabelis peab olema vastav kanne. Inventuur ei saa
-- lihtsalt kaduda

--- Isolated - transaction peab andmeid m�jutama, sekkumata teistesse
-- samaaegsetesse transactionitesse. See takistab andmete muutmist, mis 
-- p�hinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi 
-- muudetakse. Enamik DB-d kasutab tehingute isoleerimise s�ilitamiseks 
-- lukustamist

--- Durable - kui muudatus on tehtud, siis see on p�siv. Kui s�steemiviga v�i
-- voolukatkestus ilmneb enne k�skude komplekti valmimist, siis t�histatkse need 
-- k�sud ja andmed taastakse algsesse olekusse. Taastamine toimub peale 
-- s�steemi taask�ivitamist.

-- subqueries
--
create table Product
(
Id int identity primary key,
Name nvarchar(50),
Description nvarchar(250)
)

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)

insert into Product values 
('TV', '52 inch black color LCD TV'),
('Laptop', 'Very thin black color laptop'),
('Desktop', 'HP high performance desktop')

insert into ProductSales values
(3, 450, 5),
(2, 250, 7),
(3, 450, 4),
(3, 450, 9)

select * from Product
select * from ProductSales

-- kirjutame p�ringu, mis annab infot m��mata toodetest
select Id, Name, Description
from Product
where Id not in (select distinct ProductId from ProductSales)

--enamus juhtudel saab subqueriet asendada JOIN-ga
--teeme sama p�ringu JOIN-ga
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id  = ProductSales.ProductId
where ProductSales.ProductId is null

--teeme subqueri, kus kasutame select-i. Kirjutame p�ringu, kus
--saame teada NAME ja TotalQuantity veeru andmeid

select Name,
(select sum(QuantitySold) from ProductSales where ProductId = Product.Id)
as [Total Quantity]
from Product
order by Name

--sama tulemus JOIN-ga
select Name, SUM(QuantitySold) as TotalQuantity
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

-- subquerit saab subquery sisse panna
-- subquerid on alati sulgudes ja neid nimetatakse sisemisteks p�ringuteks

--- rohkete andmetega testimise tabel

truncate table Product
truncate table ProductSales

-- sisestame n�idisandmed Product tabelisse:
declare @Id int
set @Id = 1
while(@Id <= 300000)
begin
	insert into Product values('Product - ' + CAST(@Id as nvarchar(20)),
	'Product - ' + CAST(@Id as nvarchar(20)) + ' Description')

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- ProductId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000

--UnitPrice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100

--Quantity Sold
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10

declare @Counter int
set @Counter = 1

while(@Counter <= 450000)
begin
	select @RandomProductId = ROUND(((@UpperLimitForProductId -
	@LowerLimitForProductId) * Rand() + @LowerLimitForProductId), 0)

	select @RandomUnitPrice = ROUND(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * Rand() + @LowerLimitForUnitPrice), 0)

	select @RandomQuantitySold = ROUND(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * Rand() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales
	values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end
go

select * from Product
select * from ProductSales

select Id, Name, Description
from Product
where Id in
(
select Product.Id from ProductSales
)

-- teeme cache puhtaks, et uut p�ringut ei ole 
-- kuskile v�hem�llu salvestatud
checkpoint;
go
dbcc DROPCLEANBUFFERS;  -- puhastab p�ringu cache-i
go
dbcc FREEPROCCACHE;  -- puhastab t�itva planeeritud cache-i
go

-- teeme sama tabeli peale inner join p�ringu
select distinct Product.Id, Name, Description
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId
--p�ring tehti 1 sekundiga
-- teeme vahem�lu puhtaks

select Id, Name, Description
from Product
where not exists(select * from ProductSales where ProductId = Product.Id)
--1 sek
--vahem�lu puhtaks

select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

---CURSOR-id

--- realtsiooniliste DB-de halduss�steemid saavad v�ga h�sti hakkama 
--- SETS-ga. SETS lubab mitut p�ringut kombineerida �heks tulemuseks.
--- Sinna alla k�ivad UNION, INTERSECT ja EXCEPT.

update ProductSales set UnitPrice = 50 where ProductSales.ProductId = 101

--- kui on vaja rea kaupa andmeid t��delda, siis k�ige parem oleks kasutada 
--- Cursoreid. Samas on need j�udlusele halvad ja v�imalusel v�ltida. 
--- Soovitav oleks kasutada JOIN-i.

-- Cursorid jagunevad omakorda neljaks:
-- 1. Forward-Only e edasi-ainult
-- 2. Static e staatilised
-- 3. Keyset e v�tmele seadistatud
-- 4. Dynamic e d�naamiline

-- cursori n�ide:
if the ProductName = 'Product - 55', set UnitPrice to 55

----------------
declare @ProductId int
-- deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
-- open avaldusega t�idab select avaldust
-- ja sisetab tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
--- kui tulemuses on veel ridu, siis @@FETCH_STATUS on 0
while(@@FETCH_STATUS = 0)
begin
	declare @ProductName nvarchar(50)
	select @ProductName = Name from Product where Id = @ProductId

	if(@ProductName = 'Product - 55')
	begin
		update ProductSales set UnitPrice = 55 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 65')
		begin
		update ProductSales set UnitPrice = 65 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 1000')
	begin
		update ProductSales set UnitPrice = 1000 where ProductId = @ProductId
	end

	fetch next from ProductIdCursor into @ProductId
end
-- vabastab rea seadistuse e suleb cursori
close ProductIdCursor
-- vabastab ressursid, mis on seotud cursoriga
deallocate ProductIdCursor

-- vaatame, kas read on uuendatud
select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')

--- asendame cursorid JOIN-ga
update ProductSales
set UnitPrice = 
	case
		when Name = 'Product - 55' Then 155
		when Name = 'Product - 65' Then 165
		when Name like 'Product - 1000' Then 10001
	end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where Name = 'Product - 55' or Name = 'Product - 65' or
Name like 'Product - 1000'

--- vaatame tulemust
select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where (Name = 'Product - 55' or Name = 'Product - 65' 
or Name = 'Product - 1000')

--- tabelite info

--nimekiri tabelitest
select * from sysobjects where xtype = 'S'

select * from sys.tables

--- nimekiri tabelitest ja view-st
select * from INFORMATION_SCHEMA.TABLES

-- kui soovid erinevaid objektit��pe vaadata, siis kasuta XTYPE s�ntaksit
select distinct XTYPE from sysobjects IT
select * from sysobjects where XTYPE = 'V'
-- IT i internal table
-- P - stored procedure
-- PK - primary key constraint
-- S - system table
-- SQ - service queue
-- U - user table
-- V - view

--- annab teada, kas selle nimega tabel on olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES 
				where TABLE_NAME = 'EmployeeTest')
begin
	create table EmployeeTest
	(
	Id int primary key,
	Name nvarchar(30),
	Gender nvarchar(10),
	ManagerId int
	)
	print 'Table Employee created'
	end
	else
	begin
		print 'Table Employee already exists'
end

--- saab kasutada ka sisseehitatud funktsiooni: OBJECT_ID()
if OBJECT_ID('Employee') is null
begin
	print 'Table created'
end
else
begin
	print 'Table already exists'
end

--- tahame sama nimega tabeli �ra kustutada ja siis uuesti luua
if OBJECT_ID('EmployeeTest') is not null
begin
	drop table Employee
end
create table Employee
(
Id int primary key,
Name nvarchar(30),
ManagerId int
)

alter table Employee
add Email nvarchar(50)

-- kui teha uuesti k�ivitatavaks veeru kontrollimist ja loomist
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where
COLUMN_NAME = 'Emailasd' and TABLE_NAME = 'Employee' and TABLE_SCHEMA = 'dbo')
begin
	alter table Employee
	add Emailasd nvarchar(50)
end
else
begin
	print 'Column already exists'
end

--- kontrollime, kas mingi nimega veerg on olemas
if COL_LENGTH('Employee' , 'Emailasd') is not null
begin
	print 'Column already exists'
end
else
begin
	print 'Column does not exists'
end

---r 2717

-- ühendab sihttabeli lähtetabeliga ja kasutab mõlemas
-- tabelis ühist veergu
-- koodinäide:
merge[TARGET] as t
using [SOURCE] as s
	on [Join_CONDITIONS]
when matched then
	[UPDATE_STATEMENT]
when not matched by target then
	[INSERT_STATEMENT]
when not matched by source then
	[DELETE_STATEMENT]


create table StudentSource
(
Id int primary key,
Name nvarchar(20)
)

insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')

create table StudentTarget
(
Id int primary key,
Name nvarchar(20)
)

insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')
-- 1. kui leitakse klappiv rida siis studenttarget
-- tabel on uuendatud
-- 2. kui read on studentscore tabelis olemas,
-- aga neid ei ole studenttarget-s,
-- puuduolevad read sisetatakse
-- 3. kui read on olemas studenttarget s aga mitte
-- studentsources siis studenttarget
-- tabelius read kustutatakse ära


merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values(S.Id, S.Name)
when not matched by source then
	delete;

select * from StudentTarget
select * from StudentSource

--tabeli sisu tühjaks
truncate table StudentTarget
truncate table StudentSource

insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')

insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')

merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert(Id, Name) values(S.Id, S.Name);
go

select * from StudentTarget
select * from StudentSource

-- transactioni-d
-- mis see on
-- on rühm käske mis muudavad DB-s salvestatud andmeid
- tehinguid käsitletakse
-- ühe tööüksusena. kas kõik käsud õnnestuvad või mitte
-- kui üks tehing sellest ebaõnnestub
-- siis kõik juba muudetud andmed muudetakse tagsi

create table Account
(
Id int primary key,
AccountName nvarchar(25),
Balance int 
)

insert into Account values(1, 'Mark', 2000)
insert into Account values(2, 'Mary', 1000)

begin try
	begin transaction
		update Account set Balance = Balance - 100 where Id = 1
		update Account set Balance = Balance + 100 where Id = 2
	commit transaction
	print 'Transaction Commited'
end try
begin catch
	rollback tran
	print 'Transaction rolled back'
end catch

select * from Account

-- mõned levinumad probleemid
--1, dirty reaad e must lugemine
-- 2. lost updates e kadunud uuendused
-- 3. nonereapeatable reads e koumatud lugemised 
-- 4. phantom read e fantoom lugemine

--kõik eelnevad probleemid lahendatakse ära kui lubaksite igal ajal
--korraga ühel kasutajal ühe tehingu teha sellel tulemusel kõik tasemed
--satuvad järjekordfa ja neil võib tekkida vajadus kaua oodata, enne
--kui võimalus tehingut teha saabub

--- kui lubada dsamaaegselt kõik tehingud ära teha
---siis see omakorda teitab probleeme
--- probleemi lahendamiseks pakub MSSQL server erinevaid
---tehingusolatsiooni tasemeid
---et tasakaalustada samaaegsete andmete crud create read update
---ja delete probleeme

--