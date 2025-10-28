import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
from pathlib import Path

env_path = Path(__file__).parent / "db.env"
load_dotenv(dotenv_path=env_path)

PG_HOST = os.getenv("PG_HOST")
PG_PORT = os.getenv("PG_PORT")
PG_DB   = os.getenv("PG_DB")
PG_USER = os.getenv("PG_USER")
PG_PASSWORD = os.getenv("PG_PASSWORD")

for k, v in {"PG_HOST": PG_HOST, "PG_PORT": PG_PORT, "PG_DB": PG_DB, "PG_USER": PG_USER}.items():
    if not v:
        raise RuntimeError(f"環境變數 {k} 未設定，請檢查 import_Data/db.env")
    
engine = create_engine(
    f"postgresql+psycopg2://{PG_USER}:{PG_PASSWORD}@{PG_HOST}:{PG_PORT}/{PG_DB}"
)

df = pd.read_csv("cleaned_stock_info.csv", index_col=0)
df = df[df['stock_id'].astype(str).str.match(r'^\d')]
df = df[df['list_type'] != 'Index'] # 先不上傳指數資訊

df.to_sql('stock_info',engine, if_exists='append',index=False)
print(f"Successfully written {len(df)} data")