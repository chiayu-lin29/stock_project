"""
TWSE OpenAPI helper
- /exchangeReport/BWIBBU_ALL：本益比、殖利率、股價淨值比（可選 date=YYYYMMDD）
- /exchangeReport/STOCK_DAY：個股日成交資訊（需 stockNo, date=YYYYMMDD 的該月）
"""
from __future__ import annotations
import re
from typing import Optional, Iterable
from datetime import datetime
import pandas as pd
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

BASE = "https://openapi.twse.com.tw/v1"

def _session() -> requests.Session:
    s = requests.Session()
    retries = Retry(
        total=5, backoff_factor=0.6,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["GET"]
    )
    s.mount("https://", HTTPAdapter(max_retries=retries))
    s.headers.update({
        "User-Agent": "twstock-flask/1.0",
        "Accept": "application/json",
    })
    return s

def _to_num(series: pd.Series) -> pd.Series:
    # 移除千分位、逗號、空白，轉 float
    return pd.to_numeric(series.astype(str).str.replace(",", "", regex=False), errors="coerce")

def fetch_bwibbu_all(date: Optional[str]=None) -> pd.DataFrame:
    """
    取得全市場 PE/PB/殖利率。
    :param date: YYYYMMDD（可不帶）
    """
    url = f"{BASE}/exchangeReport/BWIBBU_ALL"
    params = {}
    if date:
        params["date"] = date
    s = _session()
    r = s.get(url, params=params, timeout=30)
    r.raise_for_status()
    df = pd.DataFrame(r.json())
    if df.empty:
        return df
    # 欄位正規化
    if "Date" in df.columns:
        df["Date"] = pd.to_datetime(df["Date"].astype(str), format="%Y%m%d", errors="coerce")
    for col in ("PEratio", "DividendYield", "PBratio"):
        if col in df.columns:
            df[col] = _to_num(df[col])
    return df

def fetch_stock_day(stock_no: str, yyyymm: str) -> pd.DataFrame:
    """
    下載某檔股票某「月份」的日成交資訊（開高低收、量）。
    :param stock_no: 2330, 2317 ...
    :param yyyymm: 例如 '202501'（會自動補成 20250101 給 API）
    """
    if not re.fullmatch(r"\d{6}|\d{4}", stock_no):
        raise ValueError("stock_no 應為 4~6 碼數字")
    if not re.fullmatch(r"\d{6}", yyyymm):
        raise ValueError("yyyymm 需為 6 碼，如 202501")

    url = f"{BASE}/exchangeReport/STOCK_DAY"
    params = {"stockNo": stock_no, "date": yyyymm + "01"}
    s = _session()
    r = s.get(url, params=params, timeout=30)
    r.raise_for_status()
    df = pd.DataFrame(r.json())
    if df.empty:
        return df

    # 常見欄位：Date, TradeVolume, TradeValue, OpeningPrice, HighestPrice, LowestPrice, ClosingPrice
    df["date"] = pd.to_datetime(df["Date"].astype(str), format="%Y%m%d", errors="coerce")
    df = df.sort_values("date")
    out = pd.DataFrame({
        "date": df["date"],
        "open": _to_num(df.get("OpeningPrice")),
        "high": _to_num(df.get("HighestPrice")),
        "low":  _to_num(df.get("LowestPrice")),
        "close":_to_num(df.get("ClosingPrice")),
        "volume":_to_num(df.get("TradeVolume")),
    }).dropna(subset=["date"])
    return out

def month_range(start_yyyymm: str, end_yyyymm: str) -> Iterable[str]:
    """產生 [start, end] 月份序列（含端點），格式皆為 YYYYMM。"""
    start = datetime.strptime(start_yyyymm, "%Y%m")
    end = datetime.strptime(end_yyyymm, "%Y%m")
    cur = start
    while cur <= end:
        yield cur.strftime("%Y%m")
        # 下一個月
        y = cur.year + (cur.month // 12)
        m = 1 if cur.month == 12 else cur.month + 1
        cur = cur.replace(year=y, month=m)

def fetch_stock_day_range(stock_no: str, start_yyyymm: str, end_yyyymm: str) -> pd.DataFrame:
    """連抓多個月份並合併。"""
    frames = []
    for mm in month_range(start_yyyymm, end_yyyymm):
        frames.append(fetch_stock_day(stock_no, mm))
    if not frames:
        return pd.DataFrame()
    df = pd.concat(frames, ignore_index=True).sort_values("date")
    return df.reset_index(drop=True)
