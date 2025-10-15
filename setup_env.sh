#!/usr/bin/env bash
set -e

# === Настройка переменных окружения ===
ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Создаю .env файл..."
    cat <<EOF > $ENV_FILE
# Database configuration
DB_SERVER=localhost
DB_NAME=BikeRent
DB_USER=biker_user
DB_PASSWORD=StrongP@ssw0rd123
DB_DRIVER=ODBC Driver 18 for SQL Server
EOF
    echo ".env файл создан ✅"
else
    echo ".env уже существует, пропускаем создание."
fi

# === Загрузка переменных из .env ===
export $(grep -v '^#' $ENV_FILE | xargs)

# === Проверка наличия sqlcmd ===
if ! command -v sqlcmd &> /dev/null; then
    echo "❌ sqlcmd не найден. Установи его с помощью 'sudo apt install mssql-tools18 unixodbc-dev'"
    exit 1
fi

# === Проверка подключения к серверу ===
echo "Проверяю подключение к SQL Server..."
if ! sqlcmd -S $DB_SERVER -U sa -P "$DB_PASSWORD" -Q "SELECT @@VERSION" &> /dev/null; then
    echo "⚠️ Не удалось подключиться как sa. Проверь пароль sa или запусти SQL Server."
    exit 1
fi
echo "✅ Подключение успешно."

# === Создание базы данных и пользователя ===
echo "Создаю базу данных $DB_NAME и пользователя $DB_USER..."

sqlcmd -S $DB_SERVER -U sa -P "$DB_PASSWORD" -Q "
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$DB_NAME')
BEGIN
    CREATE DATABASE [$DB_NAME];
    PRINT 'База данных $DB_NAME создана.';
END
"

sqlcmd -S $DB_SERVER -U sa -P "$DB_PASSWORD" -d $DB_NAME -Q "
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '$DB_USER')
BEGIN
    CREATE LOGIN [$DB_USER] WITH PASSWORD = '$DB_PASSWORD';
    CREATE USER [$DB_USER] FOR LOGIN [$DB_USER];
    EXEC sp_addrolemember N'db_owner', N'$DB_USER';
    PRINT 'Пользователь $DB_USER создан и добавлен в db_owner.';
END
"

echo "✅ Настройка завершена!"
