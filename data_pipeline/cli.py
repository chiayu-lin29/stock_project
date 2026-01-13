from __future__ import annotations

import argparse
from pathlib import Path
from typing import List, Optional

import pandas as pd

from .config import settings
from .exporters.csv_export import export_csv
from .providers.finmind import fetch_many
from .watchlist import get_stock_name_map, get_watchlist_stock_ids


def _validate_date(s: str) -> str:
    # 僅做格式與可解析性檢查
    try:
        pd.to_datetime(s, format="%Y-%m-%d", errors="raise")
    except Exception as e:
        raise argparse.ArgumentTypeError(f"日期格式需為 YYYY-MM-DD，收到：{s}") from e
    return s


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="data_pipeline",
        description="依使用者 watch_list 抓取指定日期區間的市場日資料並輸出 CSV",
    )

    # 來源：先做 FinMind + watch_list
    p.add_argument("--email", required=True, help="使用者 email（用於查詢 watch_list）")
    p.add_argument("--start", required=True, type=_validate_date, help="起始日 YYYY-MM-DD")
    p.add_argument("--end", required=True, type=_validate_date, help="結束日 YYYY-MM-DD")

    p.add_argument(
        "--schema",
        choices=["excel_update", "market_daily"],
        default="excel_update",
        help="輸出 CSV schema：excel_update（Excel 更新用）或 market_daily（分析用）",
    )

    p.add_argument(
        "--out",
        default="",
        help="輸出檔案路徑（含檔名）。若不填，將自動輸出到專案 out/ 資料夾",
    )

    p.add_argument(
        "--limit",
        type=int,
        default=0,
        help="限制最多抓取前 N 檔股票（除錯用；0 代表不限制）",
    )

    return p


def main():
    parser = build_parser()
    args = parser.parse_args()

    email: str = args.email.strip()
    start: str = args.start
    end: str = args.end
    schema: str = args.schema
    limit: int = int(args.limit)

    # 1) 取 watch_list
    stock_ids = get_watchlist_stock_ids(email)
    if limit > 0:
        stock_ids = stock_ids[:limit]

    if not stock_ids:
        raise SystemExit("watch_list 為空：請先在資料庫加入此使用者的關注股票（watch_list）")

    # 2) 抓取市場資料
    df = fetch_many(stock_ids, start, end)

    # 3) 準備輸出路徑
    if args.out:
        out_path = Path(args.out)
    else:
        out_dir = Path(settings.DEFAULT_OUT_DIR)
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / f"{schema}_{email}_{start}_to_{end}.csv"

    # 4) 若 schema 需要 stock_name，就從 DB join
    stock_name_map = None
    if schema == "market_daily":
        stock_name_map = get_stock_name_map(stock_ids)

    # 5) 輸出 CSV
    saved = export_csv(
        df=df,
        out_path=out_path,
        schema=schema,  # type: ignore
        source="finmind",
        stock_name_map=stock_name_map,
    )

    print(f"已輸出：{saved}")
    print(f"筆數：{len(df)}，股票數：{len(stock_ids)}，期間：{start} ~ {end}")


if __name__ == "__main__":
    main()
