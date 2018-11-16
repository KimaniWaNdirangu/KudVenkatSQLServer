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
-- A Foreign Key in one table points to a Primary Key in another table

ALTER TABLE tblPerson
ADD CONSTRAINT tblPerson_GenderID_FK
FOREIGN KEY(GenderID) REFERENCES tblGender(ID)
