import psycopg2
conn = psycopg2.connect(
    host="127.0.0.1",
    port="5433",
    database="stockdb",
    user="stock_db",
    password="0000"
)
print("Connected!")

conn.close()