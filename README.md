# BikeRent Project

Проект для работы с базой данных аренды велосипедов и расчёта премий сотрудников.

Включает:
- SQL Server базу данных с таблицами `Bicycle`, `Client`, `Staff`, `Detail`, `ServiceBook`, `RentBook` и витриной `StaffBonusFact`.
- Python-скрипты для загрузки данных, расчёта премий и вывода результатов.

---

## 📁 Файлы проекта

| Файл | Описание |
|------|----------|
| `install_sqlserver.sh` | Скрипт для установки и настройки SQL Server (Ubuntu / Linux). |
| `setup_env.sh` | Скрипт для настройки виртуального окружения Python и установки зависимостей. |
| `run_all.py` | Скрипт для выполнения всех SQL-скриптов проекта (`create_table.sql`, `alter_table.sql`, `insert_data.sql`, `StaffBonusFact.sql`, `analytics_queries.sql`). |
| `show_staff.py` | Скрипт для вывода содержимого витрины `StaffBonusFact` в консоль. |

---

## ⚡ Установка и настройка

### 1. Установка SQL Server
```bash
bash install_sqlserver.sh

Скрипт устанавливает SQL Server и создает базу данных BikeRentDB.
2. Настройка Python окружения

bash setup_env.sh

Скрипт создаёт виртуальное окружение, активирует его и устанавливает зависимости:

    pyodbc

    pandas

    python-dotenv

3. Настройка переменных окружения

Создайте файл .env в корне проекта:

DB_SERVER=localhost
DB_NAME=BikeRentDB
DB_USER=sa
DB_PASSWORD=your_password
DB_DRIVER={ODBC Driver 18 for SQL Server}

4. Запуск SQL-скриптов

python run_all.py

    Создаёт таблицы.

    Вносит изменения в существующие таблицы.

    Заполняет тестовыми данными.

    Создаёт витрину StaffBonusFact и хранимую процедуру LoadStaffBonusFact.

5. Просмотр данных витрины

python show_staff.py

Выводит содержимое StaffBonusFact в консоль.
⏰ Автоматизация загрузки витрины

Для автоматического ежедневного обновления премий сотрудников можно использовать:

    cron (Linux):

0 0 * * * /usr/bin/python3 /path/to/daily_load_bonus.py >> /path/to/logs/bonus.log 2>&1


🛠 Структура базы данных

    Bicycle – велосипеды с ценой аренды.

    Client – клиенты.

    Staff – сотрудники с датой начала работы.

    Detail – детали для обслуживания велосипедов.

    ServiceBook – обслуживание велосипедов.

    RentBook – аренда велосипедов клиентами.

    StaffBonusFact – витрина с рассчитанными премиями сотрудников.

📌 Примечания

    Перед повторным запуском run_all.py рекомендуется очистить базу данных.

    Обновления схемы через alter_table.sql учитывают корректное имя поля и типы данных.

    Витрина StaffBonusFact не хранит ссылки на другие таблицы напрямую, данные берутся через хранимую процедуру LoadStaffBonusFact.