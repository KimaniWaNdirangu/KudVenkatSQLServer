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

-- Part 3 - Creating and Working With Tables
--------------------------------------------------------------------------------
USE [Sample]
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

SELECT SCOPE_IDENTITY()
-- Same Session and SAME Scope - Used in Real World
SELECT @@IDENTITY
-- Same Session across ANY Scope
SELECT IDENT_CURRENT('Test2')
-- Specific Table across ANY Session and ANY Scop

CREATE TRIGGER trForInsert ON Test1 FOR INSERT
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