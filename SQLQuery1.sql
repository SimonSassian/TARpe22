create database  Machine

create table Car
(
Id int not null primary key,
Car nvarchar(20),
Color nvarchar(20),
EnginePower int,
Cartype nvarchar(20)
)
--- andmete sisestamine
create table CarType
(
Id int not null primary key,
CarId nvarchar(20),
CarType int
)

alter table Car add constraint FK_CarTypeId)