from __future__ import annotations

from typing import Dict, List, Optional, Sequence, Tuple

import psycopg2
from psycopg2.extras import RealDictCursor

from .config import settings


def _get_conn():
    return psycopg2.connect(
        host=settings.PG_HOST,
        port=settings.PG_PORT,
        dbname=settings.PG_DB,
        user=settings.PG_USER,
        password=settings.PG_PASSWORD,
    )


def get_watchlist_stock_ids(email: str) -> List[str]:
    """
    取得使用者啟用中的 watch_list stock_id 清單
    """
    sql = """
        SELECT w.stock_id
        FROM watch_list w
        JOIN users u ON u.id = w.user_id
        WHERE u.email = %s
          AND w.is_active = true
        ORDER BY w.added_at DESC, w.stock_id ASC;
    """
    conn = _get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (email,))
            rows = cur.fetchall()
        return [r[0] for r in rows]
    finally:
        conn.close()


def get_stock_name_map(stock_ids: Sequence[str]) -> Dict[str, str]:
    """
    從 stock_info 取得 stock_id -> stock_name
    """
    if not stock_ids:
        return {}

    # 用 ANY(%s) 方式避免拼字串
    sql = """
        SELECT stock_id, stock_name
        FROM stock_info
        WHERE stock_id = ANY(%s);
    """
    conn = _get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (list(stock_ids),))
            rows = cur.fetchall()
        return {sid: sname for sid, sname in rows}
    finally:
        conn.close()
