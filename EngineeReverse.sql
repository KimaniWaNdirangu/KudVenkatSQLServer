-- SALESDB
CREATE DATABASE 
-- -----------------------------------------------------------------------------
-- CUSTOMERS TABLE
CREATE SalesDB.dbo.Customers (
  CustomerID int IDENTITY,
  FirstName nvarchar(40) NOT NULL,
  MiddleInitial nvarchar(40) NULL,
  LastName nvarchar(40) NOT NULL,
  CONSTRAINT CustomerPK PRIMARY KEY CLUSTERED (CustomerID)
)
ON [PRIMARY]
GO

-- -----------------------------------------------------------------------------
--  EMPLOYEES TABLE
CREATE TABLE SalesDB.dbo.Employees (
  EmployeeID int IDENTITY,
  FirstName nvarchar(40) NOT NULL,
  MiddleInitial nvarchar(40) NULL,
  LastName nvarchar(40) NOT NULL,
  CONSTRAINT EmployeePK PRIMARY KEY CLUSTERED (EmployeeID)
)
ON [PRIMARY]
GO

-- -----------------------------------------------------------------------------
-- PRODUCTS TABLE

CREATE TABLE SalesDB.dbo.Products
(
    ProductID int IDENTITY,
    Name nvarchar(50) NOT NULL,
    Price money NULL,
    CONSTRAINT ProductsPK PRIMARY KEY CLUSTERED (ProductID)
)
ON [PRIMARY]
GO

-- -----------------------------------------------------------------------------
-- SALES TABLE

CREATE TABLE SalesDB.dbo.Sales (
  SalesID int IDENTITY,
  SalesPersonID int NOT NULL,
  CustomerID int NOT NULL,
  ProductID int NOT NULL,
  Quantity int NOT NULL,
  CONSTRAINT SalesPK PRIMARY KEY CLUSTERED (SalesID)
)
ON [PRIMARY]
GO

ALTER TABLE SalesDB.dbo.Sales
  ADD CONSTRAINT SalesCustomersFK FOREIGN KEY (CustomerID) REFERENCES dbo.Customers (CustomerID) ON UPDATE CASCADE
GO

ALTER TABLE SalesDB.dbo.Sales
  ADD CONSTRAINT SalesEmployeesFK FOREIGN KEY (SalesPersonID) REFERENCES dbo.Employees (EmployeeID) ON UPDATE CASCADE
GO

ALTER TABLE SalesDB.dbo.Sales
  ADD CONSTRAINT SalesProductsFK FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID) ON UPDATE CASCADE
GO