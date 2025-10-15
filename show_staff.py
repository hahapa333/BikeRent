import pandas as pd
from config import get_connection  # твоя функция подключения

def load_and_show_staff_bonus():
    query_load = "EXEC LoadStaffBonusFact;"  # вызываем хранимую процедуру
    query_select = "SELECT * FROM StaffBonusFact;"

    with get_connection() as conn:
        # 1️⃣ Заполняем витрину
        conn.cursor().execute(query_load)
        conn.commit()

        # 2️⃣ Читаем данные в pandas DataFrame
        df = pd.read_sql(query_select, conn)

    # 3️⃣ Выводим результат в консоль
    print(df)

if __name__ == "__main__":
    load_and_show_staff_bonus()
