USE BikeRentDB;
GO

------------------------
-- 1️⃣ Топ-5 наиболее рентабельных велосипедов
------------------------
SELECT TOP 5 
    b.Brand AS Bicycle,
    SUM(rb.Time * b.RentPrice) AS TotalRentalIncome,
    ISNULL(SUM(sb.Price),0) AS TotalServiceCost,
    SUM(rb.Time * b.RentPrice) - ISNULL(SUM(sb.Price),0) AS Profit
FROM Bicycle AS b
LEFT JOIN RentBook AS rb ON b.Id = rb.BicycleId
LEFT JOIN ServiceBook AS sb ON b.Id = sb.BicycleId
GROUP BY b.Id, b.Brand
ORDER BY Profit DESC;
GO

------------------------
-- 2️⃣ Общая выручка по каждому клиенту
------------------------
SELECT 
    c.Name AS Client,
    SUM(rb.Time * b.RentPrice) AS TotalSpent
FROM Client AS c
JOIN RentBook AS rb ON c.Id = rb.ClientId
JOIN Bicycle AS b ON rb.BicycleId = b.Id
WHERE rb.Paid = 1
GROUP BY c.Name
ORDER BY TotalSpent DESC;
GO

------------------------
-- 3️⃣ Список деталей, использованных для конкретного велосипеда
------------------------
SELECT 
    b.Brand AS Bicycle,
    d.Name AS Detail,
    d.Type AS DetailType,
    sb.Price AS ServicePrice,
    sb.Date AS ServiceDate
FROM ServiceBook AS sb
JOIN Bicycle AS b ON sb.BicycleId = b.Id
JOIN Detail AS d ON sb.DetailId = d.Id
WHERE b.Brand = 'Giant';
GO

------------------------
-- 4️⃣ Количество аренд по каждому велосипеду
------------------------
SELECT 
    b.Brand AS Bicycle,
    COUNT(rb.Id) AS RentalCount,
    SUM(rb.Time) AS TotalHours
FROM Bicycle AS b
LEFT JOIN RentBook AS rb ON b.Id = rb.BicycleId
GROUP BY b.Brand
ORDER BY RentalCount DESC;
GO

------------------------
-- 5️⃣ Сотрудники и доход, который они принесли (аренда + сервис)
------------------------
SELECT 
    s.Name AS Staff,
    ISNULL(SUM(rb.Time * b.RentPrice),0) AS RentalIncome,
    ISNULL(SUM(sb.Price),0) AS ServiceIncome,
    ISNULL(SUM(rb.Time * b.RentPrice),0) + ISNULL(SUM(sb.Price),0) AS TotalIncome
FROM Staff AS s
LEFT JOIN RentBook AS rb ON s.Id = rb.StaffId
LEFT JOIN Bicycle AS b ON rb.BicycleId = b.Id
LEFT JOIN ServiceBook AS sb ON s.Id = sb.StaffId
GROUP BY s.Name
ORDER BY TotalIncome DESC;
GO
