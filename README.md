# Stock Data Pipeline for Personalized Investment Analysis

> 📘 繁體中文版請見 [README.zh-TW.md](README.zh-TW.md)

---

## Overview

This project addresses a common but often overlooked problem faced by individual investors:  
while market data is widely available, personalized investment analysis remains fragmented and manual due to differences in purchase cost, entry timing, and individual stock selection.

Most existing platforms focus on market-wide indicators or price prediction. However, metrics such as returns and dividend yield are highly dependent on user-specific factors, including:
- purchase price
- holding period
- personalized stock composition (watchlist)

As a result, many investors still rely on Excel-based manual workflows, which are time-consuming and error-prone.

This project proposes a data-centric solution.  
The Minimum Viable Product (MVP) enables users to retrieve daily Taiwan stock market data based on their personal watchlists and export clean, analysis-ready CSV files that integrate seamlessly with Excel, SQL, or BI tools.

Rather than competing with prediction-oriented platforms, this project emphasizes decision support through structured data and contextual analysis. Future iterations will incorporate financial news and semantic analysis to complement quantitative market data.

---

## Problem & Goal

**Problem**
- Manual maintenance of daily stock prices leads to inconsistency and high cognitive load.
- Personalized investment metrics (e.g., yield, return) are difficult to maintain due to heterogeneous purchase costs and entry points.

**Goal**
- Replace manual Excel updates with a reproducible data pipeline.
- Enable watchlist-based, user-level data retrieval.
- Provide stable CSV outputs for downstream analysis.

---

## Key Features

- User-defined stock watchlists stored in a relational database
- Batch retrieval of daily market data via external financial APIs
- Standardized CSV export with a stable schema
- Metadata for traceability (data source, fetch timestamp)

---

## Data Source & Output Schema

### Data Source
- FinMind API: daily prices, volume, and turnover data

### Output CSV Schema (excel_update)

The natural analytical primary key is (trade_date, stock_id).

Column | Description
------ | -----------
trade_date | Trading date
stock_id | Stock identifier
close | Closing price
volume | Trading volume
source | Data source
fetched_at | Data fetch timestamp (UTC)

---

## System Design

### ER Diagram

The ER diagram illustrates analytical join paths across users, watchlists, stock metadata, and daily price records.  
The design emphasizes clear data grain and stable primary/foreign keys.

TODO: Add ER diagram at docs/diagrams/er-diagram.png

![alt text](<ER Diagram.png>)
---

### Data Pipeline Flow

1. Load configuration from environment variables  
2. Read user watchlist from the database  
3. Fetch daily stock data from external APIs  
4. Clean and standardize the schema  
5. Export CSV for downstream analysis  

TODO: Add pipeline flowchart at docs/diagrams/pipeline-flow.png

---

## How to Run

### Prerequisites
- Python 3.x
- PostgreSQL (Docker-supported)
- Environment variables configured via .env

### Environment Variables

Create a .env file in the project root (do not commit it).

Example (.env.example):

FINMIND_TOKEN=YOUR_TOKEN  
PG_HOST=127.0.0.1  
PG_PORT=5433  
PG_DB=stockdb  
PG_USER=stock_db  
PG_PASSWORD=YOUR_PASSWORD  

---

### Run CLI

python -m data_pipeline.cli \
  --email seed_user@example.com \
  --start 2025-01-01 \
  --end 2025-01-10 \
  --schema excel_update \
  --out out/excel_update.csv

---

## Data Quality & Validation

- Uniqueness of (trade_date, stock_id)
- Non-negative constraints for price and volume
- Proper handling of non-trading days (weekends and holidays)

---

## Sample SQL for Analysis

-- Retrieve user watchlist
SELECT w.stock_id
FROM watch_list w
JOIN users u ON u.id = w.user_id
WHERE u.email = 'seed_user@example.com';

-- 30-day rolling volatility
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

## Roadmap

- Scheduled daily refresh
- User-level performance metrics
- Integration of financial news and semantic analysis

---

## Notes

This project treats personalized financial data as an analytical problem rather than a prediction problem.
