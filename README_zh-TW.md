# 個人化投資分析用股市資料管線

> 📘 English version: [README.md](README.md)

---

## 專案概述

本專案源自於一個實務上普遍存在、卻常被忽略的問題：  
即使市場資料取得容易，個人化投資分析仍因購入成本、進場時間與持股組合差異，而高度仰賴人工維護，流程繁瑣且容易出錯。

目前市面上多數平台著重於市場整體指標或價格預測，但實際投資成果（如報酬率、殖利率）高度依賴使用者個人條件，包含：
- 個別股票的購入成本  
- 持有期間  
- 自選股組合  

因此，多數投資人仍需透過 Excel 手動維護每日價格與分析資料，造成時間成本與資料一致性問題。

本專案提出一個以資料為核心的解法。  
最小可行產品（MVP）聚焦於讓使用者依據個人自選股清單（watchlist）下載每日股市資料，並輸出結構穩定、可直接分析使用的 CSV 檔案，順利銜接 Excel 或 SQL 分析流程。

本專案並不以股價預測為主要目標，而是著重於透過結構化資料與情境分析，輔助投資決策。未來將結合新聞資料與語意分析，補足純量化資料的限制。

---

## 問題背景與目標

**問題**
- 每日手動更新股價流程耗時且易出錯
- 因個人購入成本與時間不同，個人化指標難以維護

**目標**
- 建立可重現的資料管線，取代人工流程
- 支援使用者層級的自選股資料下載
- 提供穩定格式的 CSV 供後續分析

---

## 核心功能

- 使用者自選股清單（資料庫管理）
- 透過外部金融 API 批次抓取每日資料
- 輸出結構穩定、可分析的 CSV
- 提供資料來源與擷取時間等追溯資訊

---

## 資料來源與輸出格式

### 資料來源
- FinMind API：每日價格與成交量資料

### CSV 輸出格式（excel_update）

分析上的自然主鍵為 (trade_date, stock_id)。

欄位 | 說明
---- | ----
trade_date | 交易日期
stock_id | 股票代碼
close | 收盤價
volume | 成交量
source | 資料來源
fetched_at | 擷取時間（UTC）

---

## 系統設計

### ER 關聯圖

ER 圖用於描述使用者、自選股清單、股票基本資料與每日價格資料之間的分析關係，重點在於資料粒度與 join 路徑的清楚定義。

TODO：補上 docs/diagrams/er-diagram.png

---

### 資料管線流程

1. 載入環境變數設定  
2. 讀取使用者自選股清單  
3. 透過 API 抓取每日市場資料  
4. 資料清理與欄位標準化  
5. 匯出 CSV 供分析使用  

TODO：補上 docs/diagrams/pipeline-flow.png

---

## 使用方式

### 環境需求
- Python 3.x
- PostgreSQL（可使用 Docker）
- .env 設定環境變數

### CLI 範例

python -m data_pipeline.cli \
  --email seed_user@example.com \
  --start 2025-01-01 \
  --end 2025-01-10 \
  --schema excel_update \
  --out out/excel_update.csv

---

## 資料品質與驗證

- (trade_date, stock_id) 唯一性
- 價格與成交量不得為負
- 正確處理非交易日（週末、休市）

---

## 分析用 SQL 範例

-- 查詢使用者自選股
SELECT w.stock_id
FROM watch_list w
JOIN users u ON u.id = w.user_id
WHERE u.email = 'seed_user@example.com';

-- 30 日滾動波動度
SELECT
  trade_date,
  stock_id,
  STDDEV(close) OVER (
    PARTITION BY stock_id
    ORDER BY trade_date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS rolling_volatility_30d
FROM stock_daily_price;

---

## 未來規劃

- 每日排程更新
- 使用者層級投資績效指標
- 結合新聞資料與語意分析

---

## 補充說明

本專案將個人化投資資料視為分析問題，而非預測問題。
