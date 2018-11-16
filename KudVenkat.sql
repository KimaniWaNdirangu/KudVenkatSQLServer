-- Part 2
-- CREATE DATABASE
CREATE DATABASE Sample

-- RENAME DATABASE

ALTER DATABASE Sample2 MODIFY NAME =  Sample3

-- USING SYSTEM STORED PROCEDURE - sp_renameDB

sp_renameDB 'Sample3', 'Sample4'

-- DROP DATABASE

DROP DATABASE master -- Error Message - Cannot drop database 'master' because it is a system database.

-- Part 3 - Creating and Working With Tables