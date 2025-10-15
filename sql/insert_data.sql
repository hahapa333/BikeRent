USE BikeRentDB;
GO

------------------------
-- Вставка тестовых данных
------------------------

-- 1️⃣ Bicycle
IF NOT EXISTS (SELECT 1 FROM Bicycle)
BEGIN
    INSERT INTO Bicycle (Brand, RentPrice) VALUES
    ('Giant', 15),
    ('Trek', 12),
    ('Merida', 18),
    ('Cannondale', 20),
    ('Specialized', 22);
END
GO

-- 2️⃣ Client
IF NOT EXISTS (SELECT 1 FROM Client)
BEGIN
    INSERT INTO Client (Name, Passport, PhoneNumber, Country) VALUES
    ('Alex', 'AA123456', '+71234567890', 'Russia'),
    ('Maria', 'BB654321', '+79876543210', 'Russia'),
    ('John', 'CC987654', '+441234567890', 'UK'),
    ('Anna', 'DD456789', '+491234567890', 'Germany'),
    ('Leo', 'EE112233', '+331234567890', 'France');
END
GO

-- 3️⃣ Staff
IF NOT EXISTS (SELECT 1 FROM Staff)
BEGIN
    INSERT INTO Staff (Name, Passport, StartDate) VALUES
    ('Ivan', 'S1111111', '2022-01-15'),
    ('Olga', 'S2222222', '2021-06-10'),
    ('Sergey', 'S3333333', '2023-03-01');
END
GO

-- 4️⃣ Detail
IF NOT EXISTS (SELECT 1 FROM Detail)
BEGIN
    INSERT INTO Detail (Brand, Type, Name, Price) VALUES
    ('Giant', 'Chain', 'Chain A', 5),
    ('Trek', 'Wheel', 'Wheel B', 20),
    ('Merida', 'Brake', 'Brake C', 15),
    ('Cannondale', 'Seat', 'Seat D', 10),
    ('Specialized', 'Pedal', 'Pedal E', 8);
END
GO

-- 5️⃣ DetailForBicycle
IF NOT EXISTS (SELECT 1 FROM DetailForBicycle)
BEGIN
    INSERT INTO DetailForBicycle (BicycleId, DetailId) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5);
END
GO

-- 6️⃣ ServiceBook (только после Staff, Bicycle и Detail)
IF NOT EXISTS (SELECT 1 FROM ServiceBook)
BEGIN
    INSERT INTO ServiceBook (BicycleId, DetailId, Date, Price, StaffId) VALUES
    (1,1,'2025-01-10', 10, 1),
    (2,2,'2025-01-11', 15, 2),
    (3,3,'2025-01-12', 12, 3),
    (4,4,'2025-01-13', 8, 1),
    (5,5,'2025-01-14', 20, 2);
END
GO

-- 7️⃣ RentBook (только после Staff, Bicycle и Client)
IF NOT EXISTS (SELECT 1 FROM RentBook)
BEGIN
    INSERT INTO RentBook (Date, Time, Paid, BicycleId, ClientId, StaffId) VALUES
    ('2025-10-01', 3, 1, 1, 1, 1),
    ('2025-10-02', 2, 1, 2, 2, 2),
    ('2025-10-03', 5, 0, 3, 3, 3),
    ('2025-10-04', 1, 1, 4, 4, 1),
    ('2025-10-05', 4, 0, 5, 5, 2);
END
GO
