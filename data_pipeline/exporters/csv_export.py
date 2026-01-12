from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Literal, Optional

import pandas as pd


SchemaName = Literal["excel_update", "market_daily"]


def _now_utc_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def export_csv(
    df: pd.DataFrame,
    out_path: str | Path,
    schema: SchemaName,
    source: str = "finmind",
    stock_name_map: Optional[Dict[str, str]] = None,
) -> Path:
    """
    依 schema 輸出 CSV

    schema = "excel_update"
      欄位：trade_date, stock_id, close, volume, source, fetched_at

    schema = "market_daily"
      欄位：trade_date, stock_id, stock_name, open, high, low, close, volume, turnover, source, fetched_at
    """
    out_path = Path(out_path)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    fetched_at = _now_utc_iso()

    if df is None or df.empty:
        if schema == "excel_update":
            empty_cols = ["trade_date", "stock_id", "close", "volume", "source", "fetched_at"]
        else:
            empty_cols = [
                "trade_date",
                "stock_id",
                "stock_name",
                "open",
                "high",
                "low",
                "close",
                "volume",
                "turnover",
                "source",
                "fetched_at",
            ]
        pd.DataFrame(columns=empty_cols).to_csv(out_path, index=False, encoding="utf-8-sig")
        return out_path

    out = df.copy()
    out["source"] = source
    out["fetched_at"] = fetched_at

    if schema == "excel_update":
        cols = ["trade_date", "stock_id", "close", "volume", "source", "fetched_at"]
        for c in cols:
            if c not in out.columns:
                out[c] = pd.NA
        out = out[cols].sort_values(["trade_date", "stock_id"])
        out.to_csv(out_path, index=False, encoding="utf-8-sig")
        return out_path

    # market_daily
    if stock_name_map is None:
        stock_name_map = {}
    out["stock_name"] = out["stock_id"].map(stock_name_map)

    cols = [
        "trade_date",
        "stock_id",
        "stock_name",
        "open",
        "high",
        "low",
        "close",
        "volume",
        "turnover",
        "source",
        "fetched_at",
    ]
    for c in cols:
        if c not in out.columns:
            out[c] = pd.NA

    out = out[cols].sort_values(["trade_date", "stock_id"])
    out.to_csv(out_path, index=False, encoding="utf-8-sig")
    return out_path
