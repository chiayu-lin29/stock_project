# Stock Backend (Flask + PostgreSQL + Redis)

A minimal-but-production-minded backend for stock data aggregation, caching, and APIs.
Tech stack: **Flask**, **SQLAlchemy**, **Alembic**, **PostgreSQL**, **Redis**, **APScheduler**, **Docker**.

---

## Project Structure

backend/
├─ app/
│ ├─ app.py # Flask app factory / blueprint 註冊（或 /health 也在此）
│ ├─ config.py # 設定（讀取 .env）
│ └─ migrations/ # Alembic 版本檔（alembic init 後生成）
├─ models/
│ ├─ init.py
│ └─ stock.py # SQLAlchemy models（範例 Stock）
├─ services/  業務邏輯(API/Cache/Schedule)
│ ├─ cache.py # Redis 連線與快取工具
│ ├─ finmind.py # 對外 API 呼叫封裝（之後接 FinMind/TWSE）
│ └─ tasks.py # APScheduler 排程任務（每日抓資料/更新 cache）
├─ test/ # 測試（pytest）
│ ├─ conftest.py
│ └─ test_health.py # /health 煙霧測試
├─ utils/  工具層 (db connection/schema 驗證/錯誤處理)
│ ├─ db.py # 資料庫 session / 初始化
│ ├─ errors.py # 統一錯誤處理 & 回傳格式
│ └─ schema.py # 請求/回應資料驗證（Pydantic/Marshmallow）
├─ .env.example
├─ alembic.ini
├─ docker-compose.yml
├─ Dockerfile
├─ requirements.txt
└─ wsgi.py # Gunicorn 入口（wsgi:app）


##  Docker Volume 對應說明
| Service | Volume Name | Mount Path |
|----------|--------------|------------|
| PostgreSQL | pg-stack_pgdata | /var/lib/postgresql/data |
| pgAdmin | pg-stack_pgadmin_data | /var/lib/pgadmin |
| Redis | backend_redis_data | /data |

###  Flask API
- URL: http://localhost:8000/health
- ENV: .env (包含 PG_USER, PG_PASSWORD, PG_DB, PG_HOST=db)


# 啟動
- docker compose up -d --build

# API
- GET /healthz