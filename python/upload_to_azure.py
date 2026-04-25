import os
import urllib
import pandas as pd
from sqlalchemy import create_engine

server = "oil-monitoring-server-claudia.database.windows.net"
database = "oil-monitoring-db"
username = "sqladmin"
password = os.getenv("AZURE_SQL_PASSWORD")

if not password:
    raise ValueError("Missing AZURE_SQL_PASSWORD environment variable.")

params = urllib.parse.quote_plus(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={server};DATABASE={database};UID={username};PWD={password};"
    "Encrypt=yes;TrustServerCertificate=no;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

df = pd.read_csv("data/sensor_data_with_anomalies.csv")
df.to_sql("sensor_data", engine, if_exists="replace", index=False)

print("Uploaded to Azure SQL successfully!")