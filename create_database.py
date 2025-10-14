from sqlalchemy import create_engine
import pyodbc

server = "localhost"
database = "BikeRentDB"
username = "sa"
password = "YourPassword"

# Подключаемся к master, чтобы проверить базу
master_conn_str = f"mssql+pyodbc://{username}:{password}@{server}/master?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
engine_master = create_engine(master_conn_str, echo=False)

with engine_master.connect() as conn:
    result = conn.execute(f"SELECT database_id FROM sys.databases WHERE Name='{database}'")
    if result.scalar() is None:
        print(f"База '{database}' не найдена. Создаём...")
        conn.execute(f"CREATE DATABASE {database}")
        print(f"База '{database}' успешно создана!")
    else:
        print(f"База '{database}' уже существует.")
