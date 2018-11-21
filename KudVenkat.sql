-- Part 2
-----------------------
-- CREATE DATABASE
CREATE DATABASE Sample

-- RENAME DATABASE

ALTER DATABASE Sample2 MODIFY NAME =  Sample3

-- USING SYSTEM STORED PROCEDURE - sp_renameDB

sp_renameDB 'Sample3', 'Sample4'

-- DROP DATABASE

DROP DATABASE master -- Error Message - Cannot drop database 'master' because it is a system database.

-- Part 3 - Creating and Working With Tables
--------------------------------------------
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
----------------------------------------------
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
---------------------------------------------

-- Part 4 - DEFAULT CONSTRAINT

SELECT * FROM tblGender
SELECT * FROM tblPerson

INSERT INTO tblGender (ID, Gender)
VALUES (1, 'Male')

INSERT INTO tblGender (ID, Gender)
VALUES (2, 'Female')

INSERT INTO tblGender (ID, Gender)
VALUES (3, 'Unknown')
-- -----------------------------------------------

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
------------------------------------------------------------
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
------------------------------------------------------------