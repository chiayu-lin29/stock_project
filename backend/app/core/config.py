#設定 dev/prod/test

from dotenv import load_dotenv
import os
from sqlalchemy import create_engine

load_dotenv()

PG_URI = f"postgresql+psycopg2://{os.getenv('PG_USER')}:{os.getenv('PG_PASSWORD')}" \
        f"@{os.getenv('PG_HOST')}:{os.getenv('PG_PORT')}/{os.getenv('PG_DB')}"
        
    

engine = create_engine(PG_URI)
FINMIND_TOKEN = os.getenv("FINMIND_TOKEN")
NEWSAPI_KEY = os.getenv("NEWSAPI_KEY")

class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "change-me")

    SQLALCHEMY_DATABASE_URI = (
        f"postgresql+psycopg2://{os.getenv('PG_USER','postgres')}:"
        f"{os.getenv('PG_PASSWORD','postgres')}@{os.getenv('PG_HOST','localhost')}:"
        f"{os.getenv('PG_PORT','5432')}/{os.getenv('PG_DB','stockdb')}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = os.getenv("SQLALCHEMY_ECHO","false").lower() == "true"

#redis/Cache
    REDIS_HOST = os.getenv("REDIS_HOST","localhost")
    REDIS_PORT = int(os.getenv("REDIS_PORT","6379"))
    REDIS_DB   = int(os.getenv("REDIS_DB","0"))
    CACHE_TTL_SECONDS = int(os.getenv("CACHE_TTL_SECONDS","3600"))

#HTTP common
    HTTP_TIMEOUT_SECONDS = float(os.getenv("HTTP_TIMEOUT_SECONDS","15"))
    HTTP_MAX_RETRIES     = int(os.getenv("HTTP_MAX_RETRIES","3"))

#External APIs
#finmind api
FINMIND_BASE=os.getenv("FINMIND_BASE")
FINMIND_TOKEN = os.getenv("FINMIND_TOKEN")
#news_api
NEWSAPI_KEY=os.getenv("NEWSAPI_KEY")