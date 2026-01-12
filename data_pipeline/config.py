from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv

# 讀取專案根目錄 .env
# 假設結構：stock_project/data_pipeline/config.py
# 則專案根目錄 = config.py 往上兩層
PROJECT_ROOT = Path(__file__).resolve().parents[1]
ENV_PATH = PROJECT_ROOT / ".env"
load_dotenv(dotenv_path=ENV_PATH, override=False)


@dataclass(frozen=True)
class Settings:
    # Provider
    FINMIND_TOKEN: str = os.getenv("FINMIND_TOKEN", "").strip()

    # Postgres (watch_list / stock_info)
    PG_HOST: str = os.getenv("PG_HOST", "127.0.0.1").strip()
    PG_PORT: int = int(os.getenv("PG_PORT", "5433"))
    PG_DB: str = os.getenv("PG_DB", "stockdb").strip()
    PG_USER: str = os.getenv("PG_USER", "stock_db").strip()
    PG_PASSWORD: str = os.getenv("PG_PASSWORD", "0000").strip()

    # Default output folder 
    DEFAULT_OUT_DIR: str = os.getenv("OUT_DIR", str(PROJECT_ROOT / "out")).strip()


settings = Settings()
