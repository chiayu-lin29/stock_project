from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, List, Optional, Tuple

import pandas as pd
import requests

from ..config import settings

FINMIND_URL = "https://api.finmindtrade.com/api/v4/data"


@dataclass(frozen=True)
class FinMindResult:
    df: pd.DataFrame
    stock_id: str
    rows: int


def _require_token():
    if not settings.FINMIND_TOKEN:
        raise RuntimeError("FINMIND_TOKEN 未設定，請在專案根目錄 .env 加入 FINMIND_TOKEN")


def fetch_daily_prices(stock_id: str, start_date: str, end_date: str) -> FinMindResult:
    """
    使用 FinMind TaiwanStockPrice 抓取指定股票在日期區間的日資料（OHLCV）
    回傳欄位（標準化後）：
      trade_date, stock_id, open, high, low, close, volume, turnover
    """
    _require_token()

    params = {
        "dataset": "TaiwanStockPrice",
        "data_id": stock_id,
        "start_date": start_date,
        "end_date": end_date,
        "token": settings.FINMIND_TOKEN,
    }

    r = requests.get(FINMIND_URL, params=params, timeout=30)
    r.raise_for_status()
    payload = r.json()

    if payload.get("status") != 200:
        raise RuntimeError(f"FinMind API 回傳錯誤：{payload}")

    data = payload.get("data", [])
    df = pd.DataFrame(data)

    if df.empty:
        # 統一回傳 schema
        empty = pd.DataFrame(
            columns=["trade_date", "stock_id", "open", "high", "low", "close", "volume", "turnover"]
        )
        return FinMindResult(df=empty, stock_id=stock_id, rows=0)

    # 常見欄位：date, open, max, min, close, Trading_Volume, Trading_money
    rename_map = {
        "date": "trade_date",
        "max": "high",
        "min": "low",
        "Trading_Volume": "volume",
        "Trading_money": "turnover",
    }
    df = df.rename(columns=rename_map)
    df["stock_id"] = stock_id

    # 保留並排序欄位
    cols = ["trade_date", "stock_id", "open", "high", "low", "close", "volume", "turnover"]
    for c in cols:
        if c not in df.columns:
            df[c] = pd.NA
    df = df[cols]

    # data_type
    df["trade_date"] = pd.to_datetime(df["trade_date"]).dt.date.astype(str)
    for c in ["open", "high", "low", "close", "turnover"]:
        df[c] = pd.to_numeric(df[c], errors="coerce")
    if "volume" in df.columns:
        df["volume"] = pd.to_numeric(df["volume"], errors="coerce")

    return FinMindResult(df=df, stock_id=stock_id, rows=len(df))


def fetch_many(stock_ids: Iterable[str], start_date: str, end_date: str) -> pd.DataFrame:
    """
    批次抓取多檔股票日資料，回傳合併後 DataFrame
    """
    frames: List[pd.DataFrame] = []
    for sid in stock_ids:
        res = fetch_daily_prices(sid, start_date, end_date)
        if res.rows > 0:
            frames.append(res.df)

    if not frames:
        return pd.DataFrame(columns=["trade_date", "stock_id", "open", "high", "low", "close", "volume", "turnover"])

    df = pd.concat(frames, ignore_index=True)
    df = df.sort_values(["trade_date", "stock_id"]).reset_index(drop=True)
    return df
