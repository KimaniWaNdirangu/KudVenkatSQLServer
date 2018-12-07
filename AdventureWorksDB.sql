-- -----------------------------------------------------------------------------
-- HUMANRESOURCES SCHEMA
-- -----------------------------------------------------------------------------

-- AdventureWorks2017.HumanResources.Department
-- -----------------------------------------------------------------------------
CREATE TABLE AdventureWorks2017.HumanResources.Department
(
    DepartmentID smallint IDENTITY,
    Name dbo.Name NOT NULL,
    GroupName dbo.Name NOT NULL,
    ModifiedDate datetime NOT NULL CONSTRAINT DF_Department_ModifiedDate DEFAULT (getdate()),
    CONSTRAINT PK_Department_DepartmentID PRIMARY KEY CLUSTERED (DepartmentID)
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX AK_Department_Name
  ON AdventureWorks2017.HumanResources.Department (Name)
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Lookup table containing the departments within the Adventure Works Cycles company.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key for Department records.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name of the department.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name of the group to which the department belongs.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'GroupName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'INDEX', N'AK_Department_Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'INDEX', N'PK_Department_DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'CONSTRAINT', N'PK_Department_DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'CONSTRAINT', N'DF_Department_ModifiedDate'
GO

-- -----------------------------------------------------------------------------
-- AdventureWorks2017.HumanResources.Employee
-- -----------------------------------------------------------------------------

CREATE TABLE AdventureWorks2017.HumanResources.Employee
(
    BusinessEntityID int NOT NULL,
    NationalIDNumber nvarchar(15) NOT NULL,
    LoginID          nvarchar(256) NOT NULL,
    OrganizationNode hierarchyid NULL,
    OrganizationLevel AS ([OrganizationNode].[GetLevel]()),
    JobTitle nvarchar(50) NOT NULL,
    BirthDate date NOT NULL,
    MaritalStatus nchar(1) NOT NULL,
    Gender nchar(1) NOT NULL,
    HireDate date NOT NULL,
    SalariedFlag dbo.Flag NOT NULL CONSTRAINT DF_Employee_SalariedFlag DEFAULT (1),
    VacationHours smallint NOT NULL CONSTRAINT DF_Employee_VacationHours DEFAULT (0),
    SickLeaveHours smallint NOT NULL CONSTRAINT DF_Employee_SickLeaveHours DEFAULT (0),
    CurrentFlag dbo.Flag NOT NULL CONSTRAINT DF_Employee_CurrentFlag DEFAULT (1),
    rowguid uniqueidentifier NOT NULL CONSTRAINT DF_Employee_rowguid DEFAULT (newid()) ROWGUIDCOL,
    ModifiedDate datetime NOT NULL CONSTRAINT DF_Employee_ModifiedDate DEFAULT (getdate()),
    CONSTRAINT PK_Employee_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID),
    CONSTRAINT CK_Employee_BirthDate CHECK ([BirthDate]>='1930-01-01' AND [BirthDate]<=dateadd(year,(-18),getdate())),
    CONSTRAINT CK_Employee_Gender CHECK (upper([Gender])='F' OR upper([Gender])='M'),
    CONSTRAINT CK_Employee_HireDate CHECK ([HireDate]>='1996-07-01' AND [HireDate]<=dateadd(day,(1),getdate())),
    CONSTRAINT CK_Employee_MaritalStatus CHECK (upper([MaritalStatus])='S' OR upper([MaritalStatus])='M'),
    CONSTRAINT CK_Employee_SickLeaveHours CHECK ([SickLeaveHours]>=(0) AND [SickLeaveHours]<=(120)),
    CONSTRAINT CK_Employee_VacationHours CHECK ([VacationHours]>=(-40) AND [VacationHours]<=(240))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX AK_Employee_LoginID
  ON AdventureWorks2017.HumanResources.Employee (LoginID)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX AK_Employee_NationalIDNumber
  ON AdventureWorks2017.HumanResources.Employee (NationalIDNumber)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX AK_Employee_rowguid
  ON AdventureWorks2017.HumanResources.Employee (rowguid)
  ON [PRIMARY]
GO

CREATE INDEX IX_Employee_OrganizationLevel_OrganizationNode
  ON AdventureWorks2017.HumanResources.Employee (OrganizationLevel, OrganizationNode)
  ON [PRIMARY]
GO

CREATE INDEX IX_Employee_OrganizationNode
  ON AdventureWorks2017.HumanResources.Employee (OrganizationNode)
  ON [PRIMARY]
GO

CREATE OR ALTER TRIGGER HumanResources.dEmployee ON HumanResources.Employee 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            (N'Employees cannot be deleted. They can only be marked as not current.', -- Message
            10, -- Severity.
            1);
        -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
END;
GO

ALTER TABLE AdventureWorks2017.HumanResources.Employee
  ADD CONSTRAINT FK_Employee_Person_BusinessEntityID FOREIGN KEY (BusinessEntityID) REFERENCES Person.Person (BusinessEntityID)
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'FK_Employee_Person_BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'INSTEAD OF DELETE trigger which keeps Employees from being deleted.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'TRIGGER', N'dEmployee'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee information such as salary, department, and title.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key for Employee records.  Foreign key to BusinessEntity.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique national identification number such as a social security number.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'NationalIDNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Network login.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'LoginID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Where the employee is located in corporate hierarchy.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'OrganizationNode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'The depth of the employee in the corporate hierarchy.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'OrganizationLevel'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Work title such as Buyer or Sales Representative.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'JobTitle'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date of birth.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'BirthDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'M = Married, S = Single', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'MaritalStatus'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'M = Male, F = Female', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'Gender'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee hired on this date.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'HireDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Job classification. 0 = Hourly, not exempt from collective bargaining. 1 = Salaried, exempt from collective bargaining.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'SalariedFlag'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Number of available vacation hours.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'VacationHours'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Number of available sick leave hours.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'SickLeaveHours'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0 = Inactive, 1 = Active', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'CurrentFlag'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'rowguid'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_LoginID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_NationalIDNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_rowguid'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'IX_Employee_OrganizationLevel_OrganizationNode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'IX_Employee_OrganizationNode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'PK_Employee_BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'PK_Employee_BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [BirthDate] >= ''1930-01-01'' AND [BirthDate] <= dateadd(year,(-18),GETDATE())', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_BirthDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [Gender]=''f'' OR [Gender]=''m'' OR [Gender]=''F'' OR [Gender]=''M''', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_Gender'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [HireDate] >= ''1996-07-01'' AND [HireDate] <= dateadd(day,(1),GETDATE())', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_HireDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [MaritalStatus]=''s'' OR [MaritalStatus]=''m'' OR [MaritalStatus]=''S'' OR [MaritalStatus]=''M''', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_MaritalStatus'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [SickLeaveHours] >= (0) AND [SickLeaveHours] <= (120)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_SickLeaveHours'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [VacationHours] >= (-40) AND [VacationHours] <= (240)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_VacationHours'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_CurrentFlag'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_rowguid'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_SalariedFlag'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_SickLeaveHours'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_VacationHours'
GO

-- -----------------------------------------------------------------------------
-- AdventureWorks2017.HumanResources.EmployeeDepartmentHistory
-- -----------------------------------------------------------------------------
CREATE TABLE AdventureWorks2017.HumanResources.EmployeeDepartmentHistory
(
    BusinessEntityID int NOT NULL,
    DepartmentID smallint NOT NULL,
    ShiftID tinyint NOT NULL,
    StartDate date NOT NULL,
    EndDate date NULL,
    ModifiedDate datetime NOT NULL CONSTRAINT DF_EmployeeDepartmentHistory_ModifiedDate DEFAULT (getdate()),
    CONSTRAINT PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID PRIMARY KEY CLUSTERED (BusinessEntityID, StartDate, DepartmentID, ShiftID),
    CONSTRAINT CK_EmployeeDepartmentHistory_EndDate CHECK ([EndDate]>=[StartDate] OR [EndDate] IS NULL)
)
ON [PRIMARY]
GO

CREATE INDEX IX_EmployeeDepartmentHistory_DepartmentID
  ON AdventureWorks2017.HumanResources.EmployeeDepartmentHistory (DepartmentID)
  ON [PRIMARY]
GO

CREATE INDEX IX_EmployeeDepartmentHistory_ShiftID
  ON AdventureWorks2017.HumanResources.EmployeeDepartmentHistory (ShiftID)
  ON [PRIMARY]
GO

ALTER TABLE AdventureWorks2017.HumanResources.EmployeeDepartmentHistory
  ADD CONSTRAINT FK_EmployeeDepartmentHistory_Department_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES HumanResources.Department (DepartmentID)
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Department.DepartmentID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Department_DepartmentID'
GO

ALTER TABLE AdventureWorks2017.HumanResources.EmployeeDepartmentHistory
  ADD CONSTRAINT FK_EmployeeDepartmentHistory_Employee_BusinessEntityID FOREIGN KEY (BusinessEntityID) REFERENCES HumanResources.Employee (BusinessEntityID)
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Employee_BusinessEntityID'
GO

ALTER TABLE AdventureWorks2017.HumanResources.EmployeeDepartmentHistory
  ADD CONSTRAINT FK_EmployeeDepartmentHistory_Shift_ShiftID FOREIGN KEY (ShiftID) REFERENCES HumanResources.Shift (ShiftID)
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Shift.ShiftID', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Shift_ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee department transfers.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Department in which the employee worked including currently. Foreign key to Department.DepartmentID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Identifies which 8-hour shift the employee works. Foreign key to Shift.Shift.ID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date the employee started work in the department.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date the employee left the department. NULL = Current department.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'IX_EmployeeDepartmentHistory_DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'IX_EmployeeDepartmentHistory_ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NUL', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'CK_EmployeeDepartmentHistory_EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'DF_EmployeeDepartmentHistory_ModifiedDate'
GO

-- -----------------------------------------------------------------------------
-- AdventureWorks2017.HumanResources.EmployeePayHistory
-- -----------------------------------------------------------------------------

CREATE TABLE AdventureWorks2017.HumanResources.EmployeePayHistory
(
    BusinessEntityID int NOT NULL,
    RateChangeDate datetime NOT NULL,
    Rate money NOT NULL,
    PayFrequency tinyint NOT NULL,
    ModifiedDate datetime NOT NULL CONSTRAINT DF_EmployeePayHistory_ModifiedDate DEFAULT (getdate()),
    CONSTRAINT PK_EmployeePayHistory_BusinessEntityID_RateChangeDate PRIMARY KEY CLUSTERED (BusinessEntityID, RateChangeDate),
    CONSTRAINT CK_EmployeePayHistory_PayFrequency CHECK ([PayFrequency]=(2) OR [PayFrequency]=(1)),
    CONSTRAINT CK_EmployeePayHistory_Rate CHECK ([Rate]>=(6.50) AND [Rate]<=(200.00))
)
ON [PRIMARY]
GO

ALTER TABLE AdventureWorks2017.HumanResources.EmployeePayHistory
  ADD CONSTRAINT FK_EmployeePayHistory_Employee_BusinessEntityID FOREIGN KEY (BusinessEntityID) REFERENCES HumanResources.Employee (BusinessEntityID)
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'FK_EmployeePayHistory_Employee_BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee pay history.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'BusinessEntityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date the change in pay is effective', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'RateChangeDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Salary hourly rate.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'Rate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 = Salary received monthly, 2 = Salary received biweekly', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'PayFrequency'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'INDEX', N'PK_EmployeePayHistory_BusinessEntityID_RateChangeDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'PK_EmployeePayHistory_BusinessEntityID_RateChangeDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [PayFrequency]=(3) OR [PayFrequency]=(2) OR [PayFrequency]=(1)', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'CK_EmployeePayHistory_PayFrequency'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Check constraint [Rate] >= (6.50) AND [Rate] <= (200.00)', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'CK_EmployeePayHistory_Rate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'DF_EmployeePayHistory_ModifiedDate'
GO