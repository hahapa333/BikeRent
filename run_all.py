import pyodbc
from config import get_connection

# 🔹 Функция выполнения одного SQL-файла


def run_sql_file(path_file):
    """Выполняет SQL-скрипт из файла."""
    with open(path_file, "r", encoding="utf-8-sig") as f:  # убираем BOM
        sql = f.read()
    conn = get_connection()
    cursor = conn.cursor()
    try:
        # Разделяем скрипт по GO, т.к. pyodbc не понимает GO
        for batch in sql.split("GO"):
            batch = batch.strip()
            if batch:
                cursor.execute(batch)
        conn.commit()
        print(f"✅ Выполнено: {path}")
    except pyodbc.Error as e:
        # показываем первые 200 символов для контекста
        print(f"❌ Ошибка: {e}\nВ запросе:\n{sql[:200]}...")
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    # Порядок выполнения скриптов
    scripts = [
        "sql/create_table.sql",       # создание таблиц
        "sql/alter_table.sql",        # исправления колонок и типов
        "sql/insert_data.sql",        # тестовые данные
        "sql/StaffBonusFact.sql",     # витрина и процедура загрузки
        "sql/analytics_queries.sql"   # аналитические запросы
    ]

    for path in scripts:
        print(f"📂 Выполняется: {path}")
        run_sql_file(path)
