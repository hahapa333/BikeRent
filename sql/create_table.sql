USE BikeRentDB;
GO

--------------------------------------------------
-- Удаляем все внешние ключи перед удалением таблиц
--------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' +
               QUOTENAME(OBJECT_NAME(parent_object_id)) +
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

EXEC sp_executesql @sql;
GO

--------------------------------------------------
-- Удаление таблиц (в правильном порядке)
--------------------------------------------------
IF OBJECT_ID('RentBook', 'U') IS NOT NULL DROP TABLE RentBook;
IF OBJECT_ID('ServiceBook', 'U') IS NOT NULL DROP TABLE ServiceBook;
IF OBJECT_ID('DetailForBicycle', 'U') IS NOT NULL DROP TABLE DetailForBicycle;
IF OBJECT_ID('Detail', 'U') IS NOT NULL DROP TABLE Detail;
IF OBJECT_ID('Staff', 'U') IS NOT NULL DROP TABLE Staff;
IF OBJECT_ID('Client', 'U') IS NOT NULL DROP TABLE Client;
IF OBJECT_ID('Bicycle', 'U') IS NOT NULL DROP TABLE Bicycle;
GO
-- create Bicycle

CREATE TABLE [Bicycle]
(
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Brand] VARCHAR(50) NOT NULL,
   [RentPrice] INT NOT NULL,
   PRIMARY KEY(Id)
);
GO

-- create Client



CREATE TABLE [Client]
(
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Name] VARCHAR(10) NOT NULL,
   [Passport] VARCHAR(50) NOT NULL,
   [Phone number] VARCHAR(50) NOT NULL,
   [Country] VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id)
);
GO

-- create Staff

CREATE TABLE [Staff]
(
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Name] VARCHAR(10) NOT NULL,
   [Passport] VARCHAR(50) NOT NULL,
   [Date] DATE NOT NULL,
   PRIMARY KEY(Id)
);
GO

-- create Detail


CREATE TABLE [Detail]
(
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Brand] VARCHAR(50) NOT NULL,
   [Type] VARCHAR(50) NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   [Price] INT NOT NULL,
   PRIMARY KEY(Id) 
);
GO

-- create DetailForBicycle


CREATE TABLE [DetailForBicycle]
(
   [BicycleId] INT NOT NULL,
   [DetailId] INT NOT NULL,
   FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
   FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
);
GO

-- create ServiceBook

CREATE TABLE [ServiceBook]
(
   [BicycleId] INT NOT NULL,
   [DetailId] INT NOT NULL,
   [Date] DATE NOT NULL,
   [Price] INT NOT NULL,
   [StaffId] INT NOT NULL,
   FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
   FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
   FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
);
GO

-- create RentBook

CREATE TABLE [RentBook]
(
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Date] DATE NOT NULL,
   [Time] INT NOT NULL,
   [Paid] BIT NOT NULL,
   [BicycleId] INT NOT NULL,
   [ClientId] INT NOT NULL,
   [StaffId] INT NOT NULL,
   FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
   FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
   FOREIGN KEY ([ClientId]) REFERENCES [Client] ([Id])
);
GO



