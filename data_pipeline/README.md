# data_pipeline

目的：提供「依使用者自選股 + 日期區間」抓取市場日資料並輸出 CSV，讓使用者可直接更新 Excel，而不需要每天手動輸入收盤價。

## depends on
- Python 3.10+
- pandas
- requests
- psycopg2-binary
- python-dotenv

之後會放在專案根目錄的 requirements.txt。

## 環境變數（專案根目錄 .env）
需要：

- FINMIND_TOKEN=xxxx
- PG_HOST=127.0.0.1
- PG_PORT=5433
- PG_DB=stockdb
- PG_USER=stock_db
- PG_PASSWORD=0000

選配：
- OUT_DIR=./out

## 使用方式

### 1 Excel 更新用（最小欄位）
輸出欄位：trade_date, stock_id, close, volume, source, fetched_at

```bash
python -m data_pipeline.cli \
  --email seed_user@example.com \
  --start 2025-08-01 \
  --end 2025-08-31 \
  --schema excel_update
