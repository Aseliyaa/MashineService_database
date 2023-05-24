/*
Created: 09.03.2023
Modified: 24.05.2023
Model: Microsoft SQL Server 2019
Database: MS SQL Server 2019
*/
USE master;
GO
DROP DATABASE IF EXISTS MachinesService;
GO
CREATE DATABASE MachinesService;
GO
USE MachinesService;
GO


-- Create tables section -------------------------------------------------

-- Table Machines

CREATE TABLE [Machines]
(
 [MachineCode] Int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
 [CountryCreator] Nvarchar(30) NOT NULL,
 [YearOfRelease] Int NOT NULL,
 [Mark] Nvarchar(30) NOT NULL,
 CONSTRAINT CK_Machines_Year CHECK (YearOfRelease > 0)
)
GO

-- Table RepairType

CREATE TABLE [RepairType]
(
 [TypeCode] Int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
 [Name] Nvarchar(30) NOT NULL,
 [Duration] Int NOT NULL,
 [Price] Money NOT NULL,
 CONSTRAINT CK_Type_Duration CHECK (Duration > 0)
)
GO

-- Table Repair

CREATE TABLE [Repair]
(
 [Id] Int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
 [MachineCode] Int NOT NULL,
	CONSTRAINT FK_Repair_Machine FOREIGN KEY (MachineCode)
 REFERENCES Machines(MachineCode),
 [TypeCode] Int NOT NULL,
 	CONSTRAINT FK_Repair_Type FOREIGN KEY (TypeCode)
 REFERENCES RepairType(TypeCode),
 [MachineType] Nvarchar(30) NOT NULL,
 [DateOfStart] Date NOT NULL,
)
GO


INSERT INTO Machines (CountryCreator, YearOfRelease, Mark)
VALUES
('USA', 2015, 'Caterpillar'),
('Japan', 2010, 'Komatsu'),
('Germany', 2018, 'Liebherr'),
('USA', 2020, 'John Deere'),
('Japan', 2017, 'Hitachi'),
('USA', 2019, 'Bobcat'),
('China', 2016, 'XCMG'),
('Russia', 2012, 'Kamaz'),
('Italy', 2014, 'Fiat-Hitachi'),
('USA', 2021, 'Case'),
('Japan', 2016, 'Kubota'),
('Germany', 2015, 'Manitou'),
('USA', 2018, 'JLG'),
('Sweden', 2011, 'Volvo'),
('Japan', 2013, 'Yanmar'),
('USA', 2017, 'Terex'),
('Germany', 2019, 'Demag'),
('USA', 2014, 'Genie'),
('China', 2010, 'Sany'),
('Japan', 2018, 'Tadano'),
('USA', 2011, 'Skyjack'),
('Sweden', 2015, 'Atlas Copco'),
('Japan', 2016, 'IHI'),
('Germany', 2017, 'Wacker Neuson'),
('USA', 2012, 'Vermeer'),
('China', 2014, 'Liugong'),
('Japan', 2019, 'Sumitomo'),
('USA', 2013, 'Gehl'),
('Belarus', 209, 'Maz'),
('Italy', 2017, 'Fiat-Hitachi');
GO

SELECT * 
FROM Machines
GO

INSERT INTO RepairType ([Name], Duration, Price)
VALUES
('Regular Maintenance', 8, 100.00),
('Oil Change', 2, 50.00),
('Hydraulic System Repair', 20, 500.00),
('Electrical System Repair', 16, 400.00),
('Engine Overhaul', 40, 1000.00),
('Transmission Repair', 24, 600.00),
('Brake System Repair', 12, 300.00),
('Suspension Repair', 18, 450.00),
('Tire Replacement', 4, 200.00),
('Body Repair', 30, 750.00);
GO 

SELECT * 
FROM RepairType
GO

INSERT INTO Repair (MachineCode, TypeCode, MachineType, DateOfStart)
VALUES
(1, 1, 'Bulldozer', '2022-01-05'),
(2, 3, 'Excavator', '2022-02-10'),
(3, 5, 'Crane', '2022-03-15'),
(4, 7, 'Backhoe', '2022-04-20'),
(5, 9, 'Loader', '2022-05-25'),
(6, 2, 'Forklift', '2022-06-30'),
(7, 4, 'Grader', '2022-07-05'),
(8, 6, 'Bulldozer', '2022-08-10'),
(9, 8, 'Excavator', '2022-09-15'),
(10, 10, 'Crane', '2022-10-20'),
(11, 1, 'Backhoe', '2022-11-25'),
(12, 3, 'Loader', '2022-12-30'),
(13, 5, 'Forklift', '2023-01-05'),
(14, 7, 'Grader', '2023-02-10'),
(15, 9, 'Bulldozer', '2023-03-15'),
(16, 2, 'Excavator', '2023-04-20'),
(17, 4, 'Crane', '2023-05-25'),
(18, 6, 'Backhoe', '2023-06-30'),
(19, 8, 'Loader', '2023-07-05'),
(20, 10, 'Forklift', '2023-08-10'),
(21, 1, 'Grader', '2023-09-15'),
(22, 3, 'Bulldozer', '2023-10-20'),
(23, 5, 'Excavator', '2023-11-25'),
(24, 7, 'Crane', '2023-12-30'),
(25, 9, 'Backhoe', '2024-01-05'),
(26, 2, 'Loader', '2024-02-10'),
(27, 4, 'Forklift', '2024-03-15'),
(28, 6, 'Grader', '2024-04-20'),
(29, 8, 'Bulldozer', '2024-05-25'),
(30, 10, 'Excavator', '2024-06-30');


SELECT * 
FROM Repair
GO

SELECT R.MachineCode, R.TypeCode, R.MachineType, R.DateOfStart
FROM Repair AS R
	INNER JOIN Machines AS M ON R.MachineCode = M.MachineCode;
GO

SELECT T.Duration, T.Name, T.Price, T.TypeCode
FROM RepairType AS T
	INNER JOIN Repair AS R ON R.TypeCode = T.TypeCode;
GO

SELECT Price, Repair.MachineCode
FROM RepairType AS R
				INNER JOIN Repair ON R.TypeCode = Repair.TypeCode

--проверим на ограничения

SELECT * FROM Machines WHERE YearOfRelease <= 0;

SELECT * FROM RepairType WHERE Duration <= 0;


--проверка наличия внешних ключей в таблице Repair
SELECT * 
FROM Repair 
WHERE MachineCode NOT IN (SELECT MachineCode 
						  FROM Machines) OR TypeCode NOT IN (SELECT TypeCode 
															 FROM RepairType);

--проверка уникальности комбинаций значений полей MachineCode и TypeCode в таблице Repair:
SELECT MachineCode, TypeCode, COUNT(*) 
FROM Repair 
GROUP BY MachineCode, TypeCode 
HAVING COUNT(*) > 1;


	
