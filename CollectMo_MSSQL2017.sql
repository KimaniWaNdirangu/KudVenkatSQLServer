USE CollectMo
Go

-- ----------------------- --
-- CREATE CollectMo TABLES --
-- ----------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Loan
CREATE TABLE Loan
(
    LoanID             INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    MemberID           INT NOT NULL, 			-- MemberID is a foreign key from 'Member' Table
    OutstandingBalance DECIMAL(18, 2) NOT NULL,
    ArrearsAmount      DECIMAL(18, 2) NOT NULL,
    DateDefaulted      DATE,
    DaysInArrears      INT NOT NULL,
    DisbursementDate   DATE,
    RepaymentAmount    DECIMAL(18, 2) NOT NULL,
    InterestRate       DECIMAL(3, 2) NOT NULL
    MemberID           INT       FOREIGN KEY REFERENCES Member(MemberID), -- MemberID is a foreign key from 'Member' Table    
	LoanTypeID         INT FOREIGN KEY REFERENCES LoanType(ID),
	DefaulterID        INT FOREIGN KEY REFERENCES Defaulter(DefaulterID)	-- DefaulterID is a foreign key from 'Defaulter' Table (ID)
);
EXEC sp_help Loan
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE LoanType
CREATE TABLE LoanType
(
	LoanTypeID   INT          NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	LoanTypeName NVARCHAR(100) NOT NULL

);
EXEC sp_help LoanType

-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Member
CREATE TABLE Member
(
	MemberID           INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName          NVARCHAR(50) NOT NULL,
	MiddleName         NVARCHAR(50),
	LastName           NVARCHAR(50) NOT NULL,
	NationalID         NVARCHAR(10),
	PassportNo         NVARCHAR(20),
	DateOfBirth        DATE         NOT NULL,
	Nationality        NVARCHAR(100),
	CountryOfResidence NVARCHAR(50), 
	ContactPersonID    INT              --  Foreign Key - References ContactPerson Table
);
EXEC sp_help Member
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Regulator
CREATE TABLE Regulator
(
	RegulatorID         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
	LegalName           NVARCHAR(100) NOT NULL,
	AcronymName         NVARCHAR(50)  NOT NULL,
	RegulatorRole       TEXT          NOT NULL,
	OfficialPhoneNo     NVARCHAR(20)  NOT NULL,
	ContactPerson       NVARCHAR(100),
	EmailAddress        NVARCHAR(100)
);
EXEC sp_help Regulator
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Auctioneer
CREATE TABLE Auctioneer
(
	AuctioneerID          INT           NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	LegalName             NVARCHAR(100) NOT NULL,
	CertificateNo         NVARCHAR(50)  NOT NULL,
	Building              NVARCHAR(50)  NOT NULL,
	Street                NVARCHAR(50)  NOT NULL,
	City                  NVARCHAR(50)  NOT NULL,
	County                NVARCHAR(50)  NOT NULL,
	OfficialPhoneNo       NVARCHAR(20)  NOT NULL,
	ContactPersonName     NVARCHAR(100),
	ContactPersonMobileNo NVARCHAR(20)  NOT NULL,
	EmailAddress          NVARCHAR(100)
);
EXEC sp_help Auctioneer 
-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE County
CREATE TABLE County
(
	CountyID   INT          NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	CountyName NVARCHAR(50),
	Region     NVARCHAR(50) NOT NULL
);
EXEC sp_help County
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Country
CREATE TABLE Country
(
	CountryID   INT          NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	CountryName NVARCHAR(50) NOT NULL,
);
EXEC sp_help Country
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Users
CREATE TABLE Users
(
	UserID       INT           NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	FirstName    NVARCHAR(50)  NOT NULL,
	MiddleName   NVARCHAR(50),
	LastName     NVARCHAR(50)  NOT NULL,
	Username     NVARCHAR(50)  NOT NULL,
	[Password]   NVARCHAR(100) NOT NULL,
	EmailAddress NVARCHAR(100) NOT NULL,
	RoleID       INT NOT NULL,
	TeamID       INT NOT NULL,
	TeamLeaderID INT NOT NULL
);
SELECT * FROM Users

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Guarantor
CREATE TABLE Guarantor
(
	GuarantorID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	MemberId    INT NOT NULL, -- Foreign Key : Primary Key of Member Table
	DefaulterID INT NOT NULL, -- Foreign Key : Primary Key of Defaulter Table
	LoanID      INT NOT NULL  -- Foreign Key : Primary Key of Loan Table
);
EXEC sp_help Guarantor
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Cases
CREATE TABLE [Case]
(
	CaseID       INT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
	LoanID       INT  NOT NULL,        -- Foreign Key - Primary Key of Loan Table
	MemberID     INT  NOT NULL,      -- Foreign Key - Primary Key of Member Table
	DateCreated  DATE NOT NULL,
	DateModified DATE NOT NULL,
	CreatedBy    INT  NOT NULL,     -- Retrieve the UserId
	ModifiedBy   DATE NOT NULL,
	CaseStatusID INT  NOT NULL,  -- Foreign Key - Primary Key of CaseStatus Table
	PortfolioID  INT  NOT NULL,   -- Foreign Key - Primary Key of Portfolio Table
	UserID       INT  NOT NULL         -- Foreign Key - Primary Key of Users Table
);
EXEC sp_help Cases
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE Defaulter
CREATE TABLE Defaulter
(
	DefaulterID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	MemberID    INT NOT NULL,
	GuarantorID INT, -- Nullable
	LoanID      INT
);
EXEC sp_help Defaulter
-- ----------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------- --
-- DROP TABLE TeamLeader
CREATE TABLE TeamLeader
(
	TeamLeaderID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	FirstName    NVARCHAR(50) NOT NULL,
	MiddleName   NVARCHAR(50),
	LastName     NVARCHAR(50) NOT NULL,
	EmployeeID   INT NOT NULL,          -- Foreign Key -  References EmployeeID from Employee Table
	BranchID     INT NOT NULL,            -- Foreign Key -  References BranchID from Branch Table
	DepartmentID INT NOT NULL         -- Foreign Key -  References DepartmentID from Deparment Table
);
EXEC sp_help TeamLeader
-- ----------------------------------------------------------------------------------------------- --

CREATE TABLE Department
(
	DepartmentID     INT           NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	DepartmentName   NVARCHAR(100) NOT NULL,
	BranchOrHQFlag   BIT           NOT NULL,
	DepartmentHeadID INT           NOT NULL	  -- Foreign Key -  References DepartmentHeadID from DepartmentHead Table
);
EXEC sp_help Department


CREATE TABLE DebtCollectionOfficer
(
	DebtCollectionOfficerID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	EmployeeID              INT NOT NULL,        -- Foreign Key -  References EmployeeID from Employee Table
	TeamID                  INT NOT NULL,        -- Foreign Key -  References TeamID from Team Table
	PortfolioID             INT NOT NULL,        -- Foreign Key -  References PortfolioID from Portfolio Table
);
EXEC sp_help DebtCollectionOfficer


CREATE TABLE Portfolio
(
	PortfolioID             INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	DebtCollectionOfficerID INT NOT NULL,
	TeamLeaderID            INT NOT NULL
);
EXEC sp_help Portfolio

-- =============================================================================================== ==
-- POPULATE TABLES --
-- =============================================================================================== ==