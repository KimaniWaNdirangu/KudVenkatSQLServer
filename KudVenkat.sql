-- Part 2
--------------------------------------------------------------------------------
-- CREATE DATABASE
CREATE DATABASE Sample

-- RENAME DATABASE

ALTER DATABASE Sample2 MODIFY NAME =  Sample3

-- USING SYSTEM STORED PROCEDURE - sp_renameDB

sp_renameDB 'Sample3', 'Sample4'

-- DROP DATABASE

DROP DATABASE master -- Error Message - Cannot drop database 'master' because it is a system database.

ALTER DATABASE [DatabaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE [DatabaseName]
GO

-- Part 3 - Creating and Working With Tables
--------------------------------------------------------------------------------
USE [Sample]
GO
-- DBForge 

CREATE TABLE Sample.dbo.tblPerson
(
	ID INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	GenderID INT NULL CONSTRAINT DF_tblPerson_GenderID DEFAULT (3),
	Age INT NULL,
	CONSTRAINT PK_tblPerson_ID PRIMARY KEY CLUSTERED (ID),
	CONSTRAINT CK_tblPerson_Age CHECK ([Age] > (0) AND [Age] < (150))
) ON [PRIMARY]
GO
-- DBForge
ALTER TABLE Sample.dbo.tblPerson
ADD CONSTRAINT FK_tblPerson_GenderID FOREIGN KEY (GenderID) REFERENCES dbo.tblGender (ID) ON DELETE CASCADE
GO


CREATE TABLE tblGender
(
	ID INT NOT NULL PRIMARY KEY,
	Gender NVARCHAR(50) NOT NULL
);

SELECT * FROM tblGender
SELECT * FROM tblPerson

-- Creating Foreign Key Constraints
------------------------------------
-- A Foreign Key in one table points to a Primary Key in another table

ALTER TABLE tblPerson
ADD CONSTRAINT tblPerson_GenderID_FK
FOREIGN KEY(GenderID) REFERENCES tblGender(ID)

-- Practice
--------------------------------------------------------------------------------
CREATE DATABASE CreditCollect

USE CreditCollect
GO

CREATE TABLE Gender
(
	ID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(50)
);

SELECT * FROM Defaulter
SELECT * FROM Gender

ALTER TABLE Defaulter
ADD CONSTRAINT FK_Defaulter_GenderID
FOREIGN KEY (GenderID) REFERENCES Gender(ID); 

-- End Practice
--------------------------------------------------------------------------------

-- Part 4 - DEFAULT CONSTRAINT

SELECT * FROM tblGender
SELECT * FROM tblPerson

INSERT INTO tblGender (ID, Gender)
VALUES (1, 'Male')

INSERT INTO tblGender (ID, Gender)
VALUES (2, 'Female')

INSERT INTO tblGender (ID, Gender)
VALUES (3, 'Unknown')
-- -----------------------------------------------------------------------------

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (3, 'Simon', 's@s.com', 1)

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (4, 'Sam', 'sam@sam.com', 1)

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (5, 'May', 'may@may.com', 2)

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (6, 'Kenny', 'k@k.com', 3)

INSERT INTO tblPerson (ID, Name, Email)
VALUES (7, 'Rich', 'r@r.com')

ALTER TABLE tblPerson
ADD CONSTRAINT DF_tblPerson_GenderID
DEFAULT 3 FOR GenderID

INSERT INTO tblPerson (ID, Name, Email)
VALUES (8, 'Mike', 'mike@r.com')

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (9, 'Sara', 's@r.com', 2)

INSERT INTO tblPerson (ID, Name, Email, GenderID)
VALUES (10, 'Johnny', 'j@r.com', NULL)

-- Dropping a Default Constraint
ALTER TABLE tblPerson
DROP CONSTRAINT DF_tblPerson_GenderID

-- Part 5 - Cascading referential integrity constraint
--------------------------------------------------------------------------------
-- Options
-- 1. No Action
-- 2. Cascade
-- 3. Set NULL
-- 4. Set Default

SELECT *
FROM tblGender
SELECT *
FROM tblPerson

DELETE FROM tblGender
WHERE ID = 1 -- 2 and 3

-- Part 6 - Check Constraint
--------------------------------------------------------------------------------
SELECT *
FROM tblPerson

INSERT INTO tblPerson
VALUES (6, 'Sara', 's@s.com', 2, 10)

INSERT INTO tblPerson
VALUES (11, 'Sara', 's@s.com', 2, NULL)

DELETE FROM tblPerson
WHERE ID = 6

-- Dropping a Check Constraint
ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

-- Adding a Check Constraint
ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)

-- Part 7 - Identity Column (Auto-Increment)
--------------------------------------------------------------------------------
SElECT *
FROM dbo.tblPerson1

INSERT INTO dbo.tblPerson1
VALUES ('John')
INSERT INTO dbo.tblPerson1
VALUES ('Tom')
INSERT INTO dbo.tblPerson1
VALUES ('Sara')

DELETE FROM tblPerson1 WHERE PersonId = 1

INSERT INTO dbo.tblPerson1
VALUES ('Tod')

INSERT INTO dbo.tblPerson1
VALUES (1, 'Jane')

/*
Msg 8101, Level 16, State 1, Line 16
An explicit value for the identity column in table 'dbo.tblPerson1' can only be specified when a column list is used and IDENTITY_INSERT is ON.
*/

SET IDENTITY_INSERT tblPerson1 ON

INSERT INTO dbo.tblPerson1 (PersonId, Name)
VALUES (1, 'Jane')

INSERT INTO dbo.tblPerson1
VALUES ('Martin')

/*
Msg 545, Level 16, State 1, Line 29
Explicit value must be specified for identity column in table 'tblPerson1' either when IDENTITY_INSERT is set to ON or when a replication user is inserting into a NOT FOR REPLICATION identity column.
*/

SET IDENTITY_INSERT tblPerson1 OFF

INSERT INTO dbo.tblPerson1
VALUES ('Martin')

DELETE FROM dbo.tblPerson1

SElECT * FROM dbo.tblPerson1

--  USe DDBC to reset the Identity Value

DBCC CHECKIDENT([dbo.tblPerson1], RESEED, 0)

INSERT INTO dbo.tblPerson1
VALUES ('Martin')

-- -----------------------------------------------------------------------------
/* Part 8 - Last Generated Identity Column Value
 * SCOPE_IDENTITY()
 * @@IDENTITY
 * IDENT CURRENT('TableName')
*/

-- User 1 Session
CREATE TABLE Test1
(
	ID INT IDENTITY(1, 1),
	Value NVARCHAR(20)
)

CREATE TABLE Test2
(
	ID INT IDENTITY(1, 1),
	Value NVARCHAR(20)
)

INSERT INTO Test1
VALUES ('X')

SELECT *
FROM Test1
SELECT *
FROM Test2

SELECT SCOPE_IDENTITY()       -- Same Session and SAME Scope - Used in Real World
SELECT @@IDENTITY             -- Same Session across ANY Scope
SELECT IDENT_CURRENT('Test2') -- Specific Table across ANY Session and ANY Scope
GO

CREATE TRIGGER trForInsert 
ON Test1 
FOR
INSERT
AS
BEGIN
	INSERT INTO Test2
	VALUES('YYYY')
END


INSERT INTO Test2
VALUES ('ZZZ')

-- User 2 Session
INSERT INTO Test2
VALUES
	('ZZZ')
--------------------------------------------------------------------------------

/*
Exact numerics 	
Unicode character strings
Approximate numerics 	
Binary strings
Date and time 	
Character strings
Other data types
*/

-- 1. EXACT NUMERICS
----------------------------------------------
-- BIT DATA TYPE
DECLARE @varBit BIT
SET     @varBit = 1
SELECT  @varBit

-- TINYINT DATA TYPE
DECLARE @varTinyInt TINYINT
SET     @varTinyInt = 256
SELECT  @varTinyInt

-- INT DATA TYPE
DECLARE @varInt INT
SET     @varInt = -256
SELECT  @varInt

-- BIGINT DATA TYPE
DECLARE @varBigInt BIGINT
SET     @varBigInt = 2544563643634453
SELECT  @varBigInt

-- DECIMAL DATA TYPE
DECLARE @varDecimal DECIMAL(6, 2)
SET     @varDecimal =  100.57
SELECT  @varDecimal

-- NUMERIC DATA TYPE
DECLARE @varNumeric NUMERIC(9, 3)
SET     @varNumeric =  12345.678
SELECT  @varNumeric

-- SMALLMONEY DATA TYPE
DECLARE @varSmallMoney SMALLMONEY
SET     @varSmallMoney = 214748.3647
SELECT  @varSmallMoney

-- MONEY DATA TYPE
DECLARE @varMoney MONEY
SET     @varMoney = 2000
SELECT  @varMoney


-- 2. APPROXIMATE NUMERICS
-- -------------------------------------------------------------
-- FLOAT DATA TYPE
DECLARE @varDate DATE
SET     @varDate = GETDATE()
SELECT  @varDate

-- 3. DATE & TIME (TEMPORAL) DATA TYPES
-- -----------------------------------
-- FLOAT DATA TYPE
DECLARE @varFloat FLOAT
SET     @varFloat = 100.23
SELECT  @varFloat

-- REAL DATA TYPE
DECLARE @varReal REAL
SET     @varReal = 100.293
SELECT  @varReal

-- DATETI DATA TYPE
DECLARE @varDateTime DATETIME
SET     @varDateTime = GETDATE()
SELECT  @varDateTime

-- DATETIME2 DATA TYPE
DECLARE @varDateTime2 DATETIME2
SET     @varDateTime2 = GETDATE()
SELECT  @varDateTime2

-- -----------------------------------
-- 4.  CHARACTER STRINGS
DECLARE @varChar CHAR(100)
SET     @varChar = 'Salah ad-Din'
SELECT  @varChar

-- NCHAR DATA TYPE
DECLARE @varNChar NCHAR(100)
SET     @varNChar = 'Salah ad-Din'
SELECT  @varNChar

-- VARCHAR DATA TYPE
DECLARE @varVarChar VARCHAR(MAX)
SET     @varVarChar = 'Salah ad-Din'
SELECT  @varVarChar

-- NVARCHAR DATA TYPE
DECLARE @varNVarChar NVARCHAR(100) -- NCARCHAR(MAX) - Store upto 2GB
SET     @varNVarChar = N'Salah ad-Din'
SELECT  @varNVarChar

-- -----------------------------------------------------------------------------
-- Part 9 - SELECT Statement

SELECT DISTINCT City FROM tblPerson

SELECT DISTINCT Name, City FROM tblPerson

SELECT * FROM tblPerson WHERE Email LIKE '%@%'

SELECT * FROM tblPerson WHERE Email NOT LIKE '%@%'

-- Exactly 1 Character Before and After the @ Symbol
SELECT * FROM tblPerson WHERE Email LIKE '_@_.com'

SELECT * FROM tblPerson WHERE Name LIKE '[MST]%'

SELECT * FROM tblPerson WHERE Name LIKE '[^MST]%'

SELECT * FROM tblPerson WHERE Age IN (20, 23, 29)

SELECT * FROM tblPerson WHERE Age BETWEEN 20 AND 25

-- JOIN
SELECT * FROM tblPerson WHERE (City = 'London' OR City = 'Thika') AND Age > 25

SELECT * FROM tblPerson
ORDER BY Name DESC, Age ASC -- Default is ASC

SELECT TOP 3 Name, Age FROM tblPerson

SELECT TOP 50 PERCENT * FROM tblPerson

-- Select TOP (Highest Value) in a Column e.g Top Salary
SELECT TOP 1 * FROM tblPerson
ORDER BY Age DESC

-- -----------------------------------------------------------------------------
/* Part 11 - GROUP BY Clause
	Aggregate Functions - COUNT, SUM, AVG, MIN, MAX

*/

SELECT *
FROM tblEmployee

SELECT SUM(Salary)
FROM tblEmployee

SELECT MIN(Salary)
FROM tblEmployee

SELECT MAX(Salary)
FROM tblEmployee

SELECT City, SUM(Salary) AS TotalSalary
FROM tblEmployee
/*
Msg 8120, Level 16, State 1, Line 10
Column 'tblEmployee.City' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
*/

SELECT City, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY City

-- GROUP BY City, Gender and TotalSalary
SELECT City, Gender, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY City, Gender
ORDER BY City

-- GROUP BY Gender, City and TotalSalary
SELECT Gender, City, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY Gender, City

SELECT COUNT(*)
FROM tblEmployee

SELECT COUNT(ID)
FROM tblEmployee

SELECT Gender, City, SUM(Salary) AS [Total Salary], COUNT(ID) AS [Total Employees]
FROM tblEmployee
GROUP BY Gender, City

SELECT Gender, City, SUM(Salary) AS [Total Salary], COUNT(ID) AS [Total Employees]
FROM tblEmployee
WHERE Gender = 'Male'
GROUP BY Gender, City

SELECT Gender, City, SUM(Salary) AS [Total Salary], COUNT(ID) AS [Total Employees]
FROM tblEmployee
GROUP BY Gender, City
HAVING Gender = 'Male'

SELECT *
FROM tblEmployee
WHERE SUM(Salary) > 4000
/* Msg 147, Level 15, State 1, Line 51
An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.
*/

SELECT Gender, City, SUM(Salary) AS [Total Salary], COUNT(ID) AS [Total Employees]
FROM tblEmployee
GROUP BY Gender, City
HAVING SUM(Salary) > 7000

-- -----------------------------------------------------------------------------
-- Part 12 - JOIN Clause
-- INNER JOIN - Returns only the matching rows.Non-matching rows are eliminated
SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	INNER JOIN tblDepartment
	ON         tblEmployee.DepartmentID = tblDepartment.ID

SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment
-- LEFT OUTER JOIN - Returns all the matching rows + non matching rows fromt the LEFT Table
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	LEFT OUTER JOIN tblDepartment
	ON              tblEmployee.DepartmentID = tblDepartment.ID

-- RIGHT OUTER JOIN - Returns all the matching rows + non matching rows from the RIGHT Table
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	RIGHT OUTER JOIN tblDepartment
	ON               tblEmployee.DepartmentID = tblDepartment.ID

-- FULL OUTER JOIN - Returns all the matching rows from BOTH Tables
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	FULL OUTER JOIN tblDepartment
	ON              tblEmployee.DepartmentID = tblDepartment.ID

-- CROSS JOIN - Returns the Cartesian Product of the 2 tables involved in the join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
CROSS JOIN tblDepartment

/*
SELECT    Column List [Columns From Both Tables]
FROM      LeftTable
JOIN_TYPE RightTable
ON        JoinCondition    

*/

-- -----------------------------------------------------------------------------
---- Part 13 - Advanced or Intelligent JOIN
-- -----------------------------------------------------------------------------
SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment
GO

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	LEFT JOIN tblDepartment
	ON	      tblEmployee.DepartmentID = tblDepartment.Id
WHERE         tblEmployee.DepartmentID IS NULL

SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment
GO

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	LEFT JOIN tblDepartment
	ON	      tblEmployee.DepartmentID = tblDepartment.Id
WHERE         tblDepartment.ID IS NULL

SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment
GO

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	RIGHT JOIN tblDepartment
	ON	       tblEmployee.DepartmentID = tblDepartment.Id
WHERE          tblEmployee.DepartmentID IS NULL

SELECT *
FROM tblEmployee
SELECT *
FROM tblDepartment
GO

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
	FULL JOIN  tblDepartment
	ON	       tblEmployee.DepartmentID = tblDepartment.Id
WHERE          tblEmployee.DepartmentID IS NULL
	OR         tblDepartment.ID IS NULL

-- -----------------------------------------------------------------------------
-- Part 13 - Advanced Or Intelligent JOINS

SELECT * FROM tblEmployee
SELECT * FROM tblDepartment

SELECT    Name, Gender, Salary, DepartmentName
FROM      tblEmployee
LEFT JOIN tblDepartment
ON        tblEmployee.DepartmentID = tblDepartment.ID
WHERE	  tblEmployee.DepartmentID IS NULL

SELECT    Name, Gender, Salary, DepartmentName
FROM      tblEmployee
LEFT JOIN tblDepartment
ON        tblEmployee.DepartmentID = tblDepartment.ID
WHERE	  tblDepartment.ID IS NULL

SELECT     Name, Gender, Salary, DepartmentName
FROM       tblEmployee
RIGHT JOIN tblDepartment
ON         tblEmployee.DepartmentID = tblDepartment.ID
WHERE	   tblEmployee.DepartmentID IS NULL

SELECT * FROM tblEmployee
SELECT * FROM tblDepartment

SELECT    Name, Gender, Salary, DepartmentID, DepartmentName
FROM      tblEmployee
FULL JOIN tblDepartment
ON        tblEmployee.DepartmentID = tblDepartment.ID
WHERE	  tblEmployee.DepartmentID IS NULL
OR        tblDepartment.ID IS NULL

-- -----------------------------------------------------------------------------
-- Part 14 - SELF JOIN
-- -----------------------------------------------------------------------------

SELECT * FROM Employee-- 

-- LEFT OUTER SELF JOIN
SELECT    E.Name AS Employee, M.Name AS Manager
FROM      Employee E
LEFT JOIN Employee M
ON	      E.ManagerID = M.EmployeeID

-- INNER SELF JOIN
SELECT     E.Name AS Employee, M.Name AS Manager
FROM       Employee E
INNER JOIN Employee M
ON		   E.ManagerID = M.EmployeeID

-- RIGHT OUTER SELF JOIN -- TODO
SELECT     E.Name AS Employee, M.Name AS Manager
FROM       Employee E
RIGHT JOIN Employee M
ON		   E.ManagerID = M.EmployeeID

-- CROSS SELF JOIN 
SELECT      E.Name AS Employee, M.Name AS Manager
FROM        Employee E
CROSS JOIN	Employee M

-- -----------------------------------------------------------------------------
-- Part 15 - Different Ways To Replace NULL
-- -----------------------------------------------------------------------------

-- ISNULL(), CASE and COALESCE()

SELECT ISNULL(NULL, 'No Manager') AS Manager
SELECT ISNULL('PRAGIM', 'No Manager') AS Manager
-- Returns PRAGIM

SELECT E.Name AS Employee, ISNULL(M.Name,'No Manager') AS Manager
FROM Employee E
	LEFT JOIN Employee M
	ON			E.ManagerID = M.EmployeeID

SELECT COALESCE(NULL, 'No Manager') AS Manager
-- Returns 'No Manager'
SELECT COALESCE('PRAGIM', 'No Manager') AS Manager
-- Returns PRAGIM


SELECT E.Name AS Employee, COALESCE(M.Name,'No Manager') AS Manager
FROM Employee E
	LEFT JOIN Employee M
	ON			E.ManagerID = M.EmployeeID

-- CASE Statement
-- CASE WHEN (Expression is True) THEN '' ELSE '' 

SELECT E.Name AS Employee, CASE WHEN M.Name IS NULL THEN 'No Manager'ELSE M.Name END AS Manager
FROM Employee E
	LEFT JOIN Employee M
	ON			E.ManagerID = M.EmployeeID

