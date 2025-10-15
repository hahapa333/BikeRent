USE BikeRentDB;
GO

------------------------
-- 1. Client: исправляем Phone number → PhoneNumber
------------------------
IF COL_LENGTH('Client', 'Phone number') IS NOT NULL
BEGIN
    ALTER TABLE Client DROP COLUMN [Phone number];
END

IF COL_LENGTH('Client', 'PhoneNumber') IS NULL
BEGIN
    ALTER TABLE Client ADD [PhoneNumber] VARCHAR(50) NOT NULL;
END
GO
-- Комментарий: поле с пробелом неудобно использовать в запросах. Исправлено на PhoneNumber.

------------------------
-- 2. Client: увеличить длину Name до 50
------------------------
ALTER TABLE Client
    ALTER COLUMN [Name] VARCHAR(50) NOT NULL;
GO
-- Комментарий: длина 10 символов слишком мала для нормальных имён.

------------------------
-- 3. Staff: увеличить длину Name до 50
------------------------
ALTER TABLE Staff
    ALTER COLUMN [Name] VARCHAR(50) NOT NULL;
GO
-- Комментарий: длина 10 символов ограничивает полные имена сотрудников.

------------------------
-- 4. Staff: переименовать Date → StartDate
------------------------
IF COL_LENGTH('Staff', 'Date') IS NOT NULL
BEGIN
    EXEC sp_rename 'Staff.Date', 'StartDate', 'COLUMN';
END
GO
-- Комментарий: поле Date слишком общее, лучше StartDate для ясности.

------------------------
-- 5. Повышаем точность денежных значений
------------------------
ALTER TABLE Bicycle ALTER COLUMN RentPrice DECIMAL(10,2) NOT NULL;
GO

ALTER TABLE Detail ALTER COLUMN Price DECIMAL(10,2) NOT NULL;
GO

ALTER TABLE ServiceBook ALTER COLUMN Price DECIMAL(10,2) NOT NULL;
GO

ALTER TABLE RentBook ALTER COLUMN Time DECIMAL(5,2) NOT NULL;
GO
