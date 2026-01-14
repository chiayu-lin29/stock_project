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
- Python 3.10
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
# 個人化投資分析用股市資料管線

> 📘 English version: [README.md](README.md)


---

## 專案概述（Overview）

儘管市場層級的金融資料高度可得，**個人化投資分析在實務上仍高度仰賴人工處理**，其核心原因在於每位投資人於購入成本、進場時間點，以及持有股票組合上皆存在顯著差異。

現有多數投資平台主要聚焦於市場整體指標或價格預測模型。然而，實際投資決策中常用的關鍵指標（如報酬率、殖利率），本質上屬於**高度使用者依賴（user-dependent）**的分析結果，需同時考量以下因素：

- 個別股票的實際購入價格  
- 持有期間長短  
- 個人化的股票組合（watchlist）

因此，許多投資人仍仰賴 Excel 等試算表工具進行每日更新與計算，該流程不僅耗時，也容易因人工操作而產生錯誤。

本專案提出一個**以資料管線（data pipeline）為核心的解決方案**。  
目前的最小可行產品（MVP）允許使用者根據個人自選股清單，自動擷取台灣股市每日資料，並輸出為**乾淨、可直接用於分析的 CSV 檔案**，可供 Excel、SQL 或商業智慧（BI）工具使用。

本專案刻意不以價格預測為目標，而是著重於**透過結構化資料與情境化分析，支援實際投資決策**。

---

## 問題定義與專案目標（Problem & Goals）

### 問題（Problems）
- 每日股價更新流程高度仰賴人工，效率低且一致性不足  
- 個人化投資指標難以在異質化的股票組合中長期維護  

### 目標（Goals）
- 以可重現（reproducible）的資料管線取代人工 Excel 流程  
- 支援以使用者為單位、基於自選股清單的資料擷取  
- 提供結構穩定、可供後續分析使用的 CSV 輸出格式  

---

## 核心功能（Key Features）

- 使用者自定義股票自選清單，並儲存於關聯式資料庫  
- 透過外部金融 API 批次擷取每日市場資料  
- 輸出具備穩定分析結構的標準化 CSV 檔案  
- 提供資料可追溯的中繼資訊（資料來源、擷取時間）  

---

## 專案狀態（Project Status）

### 已完成（Completed）
- 以自選股清單為驅動的資料擷取管線  
- 透過外部金融 API 取得每日股價資料  
- 標準化且可直接分析的 CSV 輸出（`excel_update` schema）  
- 具備明確分析資料粒度（data grain）的關聯式資料庫設計  
- ER Diagram 與端到端資料管線設計文件  

### 進行中（In Progress）
- 資料管線可觀測性與執行指標（涵蓋率、資料新鮮度）  
- API 呼叫紀錄與執行追蹤（`api_log`）  
- 支援增量更新與排程執行  

### 規劃中（Planned）
- 使用者層級的投資績效指標（報酬率、殖利率）  
- 財務基本面資料擴充（EPS、配息資訊）  
- 新聞整合與語意分析，用於提供情境化洞察  

---

## 資料來源與輸出結構（Data Source & Output Schema）

### 資料來源（Data Source）
- **FinMind API**：提供每日股價與成交量資料  

### CSV 輸出結構（`excel_update`）

本專案採用的自然分析主鍵（natural analytical primary key）為  
**(trade_date, stock_id)**。

| 欄位名稱 | 說明 |
|---------|------|
| trade_date | 交易日期 |
| stock_id | 股票代碼 |
| close | 收盤價 |
| volume | 成交量 |
| source | 資料來源 |
| fetched_at | 資料擷取時間（UTC） |

---

## 系統設計（System Design）

### ER Diagram

ER Diagram 說明使用者、自選股清單、股票中繼資料與每日價格資料之間的分析型關聯路徑，並明確定義資料粒度與穩定的主鍵／外鍵結構。

![ER Diagram](docs/diagrams/ER%20Diagram.png)

### 資料管線流程（Data Pipeline Flow）

本資料管線以可重現與分析導向為設計原則：

1. 自環境變數載入設定  
2. 自資料庫解析使用者自選股清單  
3. 透過外部 API 擷取每日股票資料  
4. 驗證、清理並標準化資料結構  
5. 匯出 CSV 檔案供後續分析使用  

![Pipeline Flow](docs/diagrams/pipeline-flow.png)

---

## 技術架構（Technology Stack）

### 資料與後端（Data & Backend）
- **程式語言**：Python  
- **資料庫**：PostgreSQL  
- **外部 API**：FinMind（台灣股市資料）

### 資料處理（Data Processing）
- 批次導向的資料擷取流程  
- 基於自然複合鍵的冪等性（idempotent）寫入策略  
- 為分析需求設計的結構標準化  

### 工具（Tooling）
- Docker（本地 PostgreSQL 環境）  
- 透過 `.env` 進行環境設定管理  
- Git 版本控制  

---

## 快速開始（Getting Started）

### 先決條件（Prerequisites）
- Python 3.10+  
- PostgreSQL（支援 Docker）  
- 已設定完成的 `.env` 環境變數  

### CLI 執行方式（Run via CLI）

```bash
python -m data_pipeline.cli \
  --email seed_user@example.com \
  --start 2025-01-01 \
  --end 2025-01-10 \
  --schema excel_update \
  --out out/excel_update.csv
```

此指令將根據指定使用者的自選股清單，擷取對應期間內的每日股票資料，並輸出為標準化 CSV 檔案。

---

## 資料品質與驗證（Data Quality & Validation）

- (trade_date, stock_id) 唯一性限制
- 價格與成交量欄位之非負值約束
- 正確處理非交易日（週末與國定假日）

### Sample SQL

```sql
SELECT w.stock_id
FROM user_watch_list w
JOIN user_users u ON u.id = w.user_id
WHERE u.email = 'seed_user@example.com';
```

---

## Roadmap

-  支援每日自動排程更新
-  使用者層級投資績效指標
-  財經新聞與語意分析整合

---

## Team

本專案以明確的系統模組分工進行協作開發。

**Frontend Development / UI–UX Design**: Zhuowen Chen  
GitHub: [@Zhuowen-Chen](https://github.com/Zhuowen-Chen)

**Data Modeling & Analytical Schema Design**: Chiayu Lin  
GitHub: [@chiayu-lin29](https://github.com/chiayu-lin29)

**Backend Development / Data Pipeline Design**: Chiayu Lin, Zhuowen Chen  
GitHub: [@chiayu-lin29](https://github.com/chiayu-lin29), [@Zhuowen-Chen](https://github.com/Zhuowen-Chen)

---


## Contact

chiayulin22@gmail.com
zhuowenchen1993@gmail.com

