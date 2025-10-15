USE BikeRentDB;
GO

CREATE OR ALTER PROCEDURE LoadStaffBonusFact
AS
BEGIN
    SET NOCOUNT ON;

    -- Очищаем витрину
    DELETE FROM StaffBonusFact;

    -- Рассчитываем премии по формуле
    INSERT INTO StaffBonusFact (Year, Month, StaffId, StaffName, Bonus)
    SELECT
        YEAR(ISNULL(rb.Date, sb.Date)) AS Year,
        MONTH(ISNULL(rb.Date, sb.Date)) AS Month,
        s.Id AS StaffId,
        s.Name AS StaffName,
        SUM(
            ((ISNULL(rb.Time * b.RentPrice, 0) * 0.3) + (ISNULL(sb.Price, 0) * 0.8))
            * CASE
                WHEN DATEDIFF(YEAR, s.StartDate, GETDATE()) < 1 THEN 0.05
                WHEN DATEDIFF(YEAR, s.StartDate, GETDATE()) BETWEEN 1 AND 2 THEN 0.10
                ELSE 0.15
              END
        ) AS Bonus
    FROM Staff s
    LEFT JOIN RentBook rb ON rb.StaffId = s.Id
    LEFT JOIN Bicycle b ON rb.BicycleId = b.Id
    LEFT JOIN ServiceBook sb ON sb.StaffId = s.Id
    GROUP BY
        YEAR(ISNULL(rb.Date, sb.Date)),
        MONTH(ISNULL(rb.Date, sb.Date)),
        s.Id,
        s.Name;
END;
GO


/* --------------------------------------------
   5. Автоматизация загрузки витрины (описание)
-------------------------------------------- */

/*
Автоматизация возможна следующими способами:

1️⃣ SQL Server Agent:
    - Создать Job → Step: EXEC dbo.LoadStaffBonusFact;
    - Настроить расписание: ежедневно в 00:05.

2️⃣ PowerShell + Планировщик Windows:
    - Команда:
        Invoke-Sqlcmd -ServerInstance "localhost" -Database "BikeRent" -Query "EXEC dbo.LoadStaffBonusFact;"
    - Добавить в Task Scheduler.

3️⃣ Python:
    - Использовать SQLAlchemy/pyodbc для вызова процедуры из Python-скрипта.
    Автоматизация через:
    cron (для Linux/macOS)
    0 0 * * * /usr/bin/python3 /home/a/PycharmProjects/BikeRent/show_staff.py >> /home/a/PycharmProjects/BikeRent/logs/bonus.log 2>&1


*/